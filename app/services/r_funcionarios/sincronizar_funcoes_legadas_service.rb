# frozen_string_literal: true

module RFuncionarios
  class SincronizarFuncoesLegadasService
    def self.call(r_funcionario:)
      new(r_funcionario:).call
    end

    def initialize(r_funcionario:)
      @r_funcionario = r_funcionario
    end

    def call
      return Result.success(r_funcionario, HttpStatus::OK, "Nenhum vinculo de setor-funcao para sincronizar") if vinculos_para_sincronizacao.empty?

      sincronizar_funcoes_desejadas!
      desativar_funcoes_legadas_obsoletas!

      Result.success(r_funcionario, HttpStatus::OK, "Funcoes legadas sincronizadas com sucesso")
    end

    private

    attr_reader :r_funcionario

    def vinculos_para_sincronizacao
      @vinculos_para_sincronizacao ||= r_funcionario
        .r_funcionarios_setores_funcoes
        .reject(&:marked_for_destruction?)
    end

    def vinculos_ativos
      @vinculos_ativos ||= vinculos_para_sincronizacao
        .select(&:ativo?)
    end

    def funcoes_desejadas
      @funcoes_desejadas ||= vinculos_ativos
        .group_by { |vinculo| vinculo.r_setor_funcao&.r_funcao_id }
        .each_with_object({}) do |(r_funcao_id, vinculos), hash|
          next if r_funcao_id.blank?

          hash[r_funcao_id] = {
            principal: vinculos.any?(&:principal?),
            ativo: vinculos.any?(&:ativo?),
            data_inicio: vinculos.filter_map(&:data_inicio).min,
            data_fim: vinculos.filter_map(&:data_fim).max
          }
        end
    end

    def sincronizar_funcoes_desejadas!
      funcoes_desejadas.each do |r_funcao_id, atributos|
        vinculo_legado = r_funcionario.r_funcionarios_funcoes.with_deleted.find_or_initialize_by(r_funcao_id:)
        vinculo_legado.assign_attributes(
          principal: atributos[:principal],
          ativo: atributos[:ativo],
          data_inicio: atributos[:data_inicio] || vinculo_legado.data_inicio,
          data_fim: atributos[:data_fim],
          deleted_at: nil
        )
        vinculo_legado.save!
      end
    end

    def desativar_funcoes_legadas_obsoletas!
      scope = r_funcionario.r_funcionarios_funcoes
      scope = if funcoes_desejadas.empty?
                scope
              else
                scope.where.not(r_funcao_id: funcoes_desejadas.keys)
              end

      scope.find_each do |vinculo_legado|
        vinculo_legado.destroy
      end
    end
  end
end
