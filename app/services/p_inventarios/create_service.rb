# frozen_string_literal: true

module PInventarios
  # Cria o inventario e ja pre-popula p_inventarios_itens com todos os
  # patrimonios ativos (nao baixados) do escopo escolhido: ambiente, bloco,
  # predio ou, se nenhum for informado, a unidade gestora inteira.
  class CreateService
    def self.call(g_unidade_gestora_id:, params:)
      new(g_unidade_gestora_id:, params:).call
    end

    def initialize(g_unidade_gestora_id:, params:)
      @g_unidade_gestora_id = g_unidade_gestora_id
      @params = params
    end

    def call
      resultado = nil
      inventario = nil

      ApplicationRecord.transaction do
        inventario = PInventario.new(
          g_unidade_gestora_id: g_unidade_gestora_id,
          descricao: params[:descricao],
          r_funcionario_responsavel_id: params[:r_funcionario_responsavel_id],
          i_predio_id: params[:i_predio_id],
          i_bloco_id: params[:i_bloco_id],
          i_ambiente_predial_id: params[:i_ambiente_predial_id],
          data_inicio: params[:data_inicio] || Time.current,
          observacao: params[:observacao]
        )

        unless inventario.save
          resultado = falha(inventario.errors.full_messages)
          raise ActiveRecord::Rollback
        end

        patrimonios_do_escopo.find_each do |p_patrimonio|
          inventario.p_inventarios_itens.create!(p_patrimonio: p_patrimonio, encontrado: false)
        end
      end

      resultado || Result.success(inventario, HttpStatus::CREATED, "Inventario criado com sucesso")
    end

    private

    attr_reader :g_unidade_gestora_id, :params

    def patrimonios_do_escopo
      escopo = PPatrimonio.where(g_unidade_gestora_id: g_unidade_gestora_id)
                           .joins(:p_situacao_patrimonio)
                           .where.not(p_situacoes_patrimonios: { codigo: "BAIXADO" })

      if params[:i_ambiente_predial_id].present?
        escopo.where(i_ambiente_predial_id: params[:i_ambiente_predial_id])
      elsif params[:i_bloco_id].present?
        escopo.joins(:i_ambiente_predial).where(i_ambientes_prediais: { i_bloco_id: params[:i_bloco_id] })
      elsif params[:i_predio_id].present?
        escopo.joins(i_ambiente_predial: :i_bloco).where(i_blocos: { i_predio_id: params[:i_predio_id] })
      else
        escopo
      end
    end

    def falha(errors)
      Result.failure(errors, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel criar o inventario")
    end
  end
end
