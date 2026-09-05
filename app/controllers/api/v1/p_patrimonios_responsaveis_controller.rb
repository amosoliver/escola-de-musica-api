# frozen_string_literal: true

class Api::V1::PPatrimoniosResponsaveisController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = %i[g_pessoa_id data_inicio observacao principal].freeze

  before_action :set_p_patrimonio

  def index
    query = @p_patrimonio.p_patrimonios_responsaveis.includes(:g_pessoa).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: PPatrimonioResponsavelBlueprint)
  end

  def create
    result = PPatrimoniosResponsaveis::CreateService.call(p_patrimonio: @p_patrimonio, params: p_patrimonio_responsavel_params)
    render ResponseService.handle_service_result(result, blueprint: PPatrimonioResponsavelBlueprint)
  end

  private

  def set_p_patrimonio
    @p_patrimonio = tenant_scope(PPatrimonio.all).find(params[:p_patrimonio_id])
  end

  def p_patrimonio_responsavel_params
    params.require(:p_patrimonio_responsavel).permit(*PERMITTED_ATTRIBUTES).to_h.symbolize_keys
  end
end
