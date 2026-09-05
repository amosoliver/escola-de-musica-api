# frozen_string_literal: true

class Api::V1::PPatrimoniosController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = %i[
    g_unidade_gestora_id g_instrumento_id g_tipo_patrimonio_id i_ambiente_predial_id
    p_estado_conservacao_patrimonio_id p_situacao_patrimonio_id p_tipo_aquisicao_patrimonio_id
    codigo_patrimonial codigo_barras qr_code descricao marca modelo numero_serie
    data_aquisicao data_garantia_fim valor_aquisicao observacao ativo
  ].freeze

  DESTINO_EXTERNO_ATTRIBUTES = %i[
    g_bairro_id nome razao_social cpf_cnpj email telefone cep logradouro numero complemento observacao
  ].freeze

  GCATEGORIA_PATRIMONIO_ATTRIBUTES = %i[codigo descricao ativo].freeze

  GTIPO_PATRIMONIO_ATTRIBUTES = %i[codigo descricao representa_instrumento ativo].freeze

  before_action :set_p_patrimonio, only: %i[show update destroy transferir vender doar descartar]

  def index
    query = scoped_p_patrimonios.includes(index_associations).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: PPatrimonioBlueprint)
  end

  def show
    render ResponseService.success(data: @p_patrimonio, message: "Patrimonio encontrado com sucesso", blueprint: PPatrimonioBlueprint)
  end

  def create
    attributes = enforce_tenant_attribute!(p_patrimonio_params.to_h.deep_symbolize_keys)
    return if performed?

    result = PPatrimonios::CreateService.call(params: attributes)
    render ResponseService.handle_service_result(result, blueprint: PPatrimonioBlueprint)
  end

  def update
    attributes = enforce_tenant_attribute!(p_patrimonio_params.to_h.deep_symbolize_keys)
    return if performed?

    result = PPatrimonios::UpdateService.call(p_patrimonio: @p_patrimonio, params: attributes)
    render ResponseService.handle_service_result(result, blueprint: PPatrimonioBlueprint)
  end

  def destroy
    result = PPatrimonios::DestroyService.call(p_patrimonio: @p_patrimonio)
    render ResponseService.handle_service_result(result)
  end

  # POST /p_patrimonios/:id/transferir
  # Transferencia interna entre ambientes prediais da mesma unidade gestora.
  def transferir
    result = PPatrimonios::TransferenciaService.call(p_patrimonio: @p_patrimonio, params: transferencia_params)
    render ResponseService.handle_service_result(result, blueprint: PPatrimonioBlueprint)
  end

  # POST /p_patrimonios/:id/vender
  def vender
    result = PPatrimonios::SaidaDefinitivaService.call(
      p_patrimonio: @p_patrimonio, params: saida_definitiva_params,
      tipo_movimentacao_codigo: "VENDA", tipo_baixa_codigo: "VENDA"
    )
    render ResponseService.handle_service_result(result, blueprint: PBaixaPatrimonioBlueprint)
  end

  # POST /p_patrimonios/:id/doar
  def doar
    result = PPatrimonios::SaidaDefinitivaService.call(
      p_patrimonio: @p_patrimonio, params: saida_definitiva_params,
      tipo_movimentacao_codigo: "DOACAO", tipo_baixa_codigo: "DOACAO"
    )
    render ResponseService.handle_service_result(result, blueprint: PBaixaPatrimonioBlueprint)
  end

  # POST /p_patrimonios/:id/descartar
  def descartar
    result = PPatrimonios::SaidaDefinitivaService.call(
      p_patrimonio: @p_patrimonio, params: saida_definitiva_params,
      tipo_movimentacao_codigo: "DESCARTE", tipo_baixa_codigo: "DESCARTE"
    )
    render ResponseService.handle_service_result(result, blueprint: PBaixaPatrimonioBlueprint)
  end

  private

  def set_p_patrimonio
    @p_patrimonio = scoped_p_patrimonios.find(params[:id])
  end

  def index_associations
    [
      :g_unidade_gestora, :i_ambiente_predial, :p_estado_conservacao_patrimonio,
      :p_situacao_patrimonio, :p_tipo_aquisicao_patrimonio,
      { g_instrumento: { g_tipo_instrumento: :g_classificacao_instrumento } },
      { g_tipo_patrimonio: :g_categoria_patrimonio }
    ]
  end

  def scoped_p_patrimonios
    tenant_scope(PPatrimonio.all)
  end

  def p_patrimonio_params
    params.require(:p_patrimonio).permit(
      *PERMITTED_ATTRIBUTES,
      g_tipo_patrimonio_attributes: [
        *GTIPO_PATRIMONIO_ATTRIBUTES,
        :g_categoria_patrimonio_id,
        { g_categoria_patrimonio_attributes: GCATEGORIA_PATRIMONIO_ATTRIBUTES }
      ]
    )
  end

  def transferencia_params
    params.permit(:i_ambiente_predial_destino_id, :r_funcionario_id, :motivo, :observacao).to_h.symbolize_keys
  end

  def saida_definitiva_params
    params.permit(
      :p_destino_externo_id, :r_funcionario_id, :motivo, :data_baixa, :valor,
      :documento, :numero_documento, :justificativa, :observacao,
      p_destino_externo_attributes: DESTINO_EXTERNO_ATTRIBUTES
    ).to_h.deep_symbolize_keys
  end
end
