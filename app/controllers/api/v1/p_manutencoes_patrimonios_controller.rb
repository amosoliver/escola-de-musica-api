# frozen_string_literal: true

class Api::V1::PManutencoesPatrimoniosController < ApplicationController
  include Pagy::Method

  DESTINO_EXTERNO_ATTRIBUTES = %i[
    g_bairro_id nome razao_social cpf_cnpj email telefone cep logradouro numero complemento observacao
  ].freeze

  before_action :set_p_manutencao_patrimonio, only: %i[show aprovar agendar iniciar concluir cancelar]

  def index
    query = scoped_p_manutencoes.includes(index_associations).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: PManutencaoPatrimonioBlueprint)
  end

  def show
    render ResponseService.success(data: @p_manutencao_patrimonio, message: "Manutencao encontrada com sucesso", blueprint: PManutencaoPatrimonioBlueprint)
  end

  def create
    p_patrimonio = tenant_scope(PPatrimonio.all).find(create_params[:p_patrimonio_id])
    result = PManutencoesPatrimonios::CreateService.call(p_patrimonio: p_patrimonio, params: create_params)
    render ResponseService.handle_service_result(result, blueprint: PManutencaoPatrimonioBlueprint)
  end

  # POST /p_manutencoes_patrimonios/:id/aprovar
  def aprovar
    render_status_result("APROVADA")
  end

  # POST /p_manutencoes_patrimonios/:id/agendar
  def agendar
    render_status_result("AGENDADA")
  end

  # POST /p_manutencoes_patrimonios/:id/iniciar
  def iniciar
    render_status_result("EM_ANDAMENTO", attributes: { data_inicio: params[:data_inicio] || Time.current })
  end

  # POST /p_manutencoes_patrimonios/:id/concluir
  def concluir
    result = PManutencoesPatrimonios::ConcluirService.call(p_manutencao_patrimonio: @p_manutencao_patrimonio, params: concluir_params)
    render ResponseService.handle_service_result(result, blueprint: PManutencaoPatrimonioBlueprint)
  end

  # POST /p_manutencoes_patrimonios/:id/cancelar
  def cancelar
    render_status_result("CANCELADA")
  end

  private

  def render_status_result(codigo, attributes: {})
    result = PManutencoesPatrimonios::AtualizarStatusService.call(
      p_manutencao_patrimonio: @p_manutencao_patrimonio, novo_status_codigo: codigo, attributes: attributes
    )
    render ResponseService.handle_service_result(result, blueprint: PManutencaoPatrimonioBlueprint)
  end

  def set_p_manutencao_patrimonio
    @p_manutencao_patrimonio = scoped_p_manutencoes.find(params[:id])
  end

  def index_associations
    [
      :p_patrimonio, :p_tipo_manutencao_patrimonio, :p_status_manutencao_patrimonio,
      :p_destino_externo, { r_funcionario_solicitante: :g_pessoa }
    ]
  end

  def scoped_p_manutencoes
    tenant_scope(PManutencaoPatrimonio.all)
  end

  def create_params
    params.permit(
      :p_patrimonio_id, :p_tipo_manutencao_patrimonio_id, :descricao_problema, :data_prevista,
      :valor_estimado, :observacao, :r_funcionario_solicitante_id, :p_destino_externo_id,
      p_destino_externo_attributes: DESTINO_EXTERNO_ATTRIBUTES
    ).to_h.deep_symbolize_keys
  end

  def concluir_params
    params.permit(:descricao_servico, :valor_realizado, :data_conclusao, :r_funcionario_id).to_h.symbolize_keys
  end
end
