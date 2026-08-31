# frozen_string_literal: true

class Api::V1::RSetoresController < ApplicationController
  include Pagy::Method

  PERMITTED_ATTRIBUTES = [
    :g_unidade_gestora_id,
    :r_setor_pai_id,
    :codigo,
    :descricao,
    :ordem,
    :ativo,
    r_setores_funcoes_attributes: %i[id r_funcao_id principal ativo _destroy]
  ].freeze

  before_action :set_r_setor, only: %i[show update destroy]

  def index
    query = scoped_r_setores.includes(:g_unidade_gestora, :r_setor_pai, :r_setores_filhos, r_setores_funcoes: :r_funcao).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: RSetorBlueprint)
  end

  def show
    render ResponseService.success(data: @r_setor, message: "Setor encontrado com sucesso", blueprint: RSetorBlueprint)
  end

  def create
    attributes = enforce_tenant_attribute!(r_setor_params.to_h.deep_symbolize_keys)
    return if performed?

    result = RSetores::CreateService.call(params: attributes)
    render ResponseService.handle_service_result(result, blueprint: RSetorBlueprint)
  end

  def update
    attributes = enforce_tenant_attribute!(r_setor_params.to_h.deep_symbolize_keys)
    return if performed?

    result = RSetores::UpdateService.call(r_setor: @r_setor, params: attributes)
    render ResponseService.handle_service_result(result, blueprint: RSetorBlueprint)
  end

  def destroy
    result = RSetores::DestroyService.call(r_setor: @r_setor)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_r_setor
    @r_setor = scoped_r_setores.find(params[:id])
  end

  def scoped_r_setores
    tenant_scope(RSetor.all)
  end

  def r_setor_params
    params.require(:r_setor).permit(*PERMITTED_ATTRIBUTES)
  end
end
