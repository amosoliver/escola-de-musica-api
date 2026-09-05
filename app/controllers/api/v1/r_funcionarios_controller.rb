# frozen_string_literal: true

class Api::V1::RFuncionariosController < ApplicationController
  include Pagy::Method

  G_PESSOA_ATTRIBUTES = Api::V1::GPessoasController::PERMITTED_ATTRIBUTES - %i[
    u_perfil_id
    g_unidade_gestora_id
    ativo
  ]

  PERMITTED_ATTRIBUTES = [
    :g_pessoa_id,
    :atualizar_g_pessoa,
    :g_unidade_gestora_id,
    :r_tipo_vinculo_id,
    :matricula,
    :data_inicio,
    :data_fim,
    :ativo,
    { g_pessoa_attributes: G_PESSOA_ATTRIBUTES },
    { r_funcionarios_especialidades_attributes: %i[
      id
      r_especialidade_id
      principal
      data_inicio
      data_fim
      ativo
      _destroy
    ] },
    { r_funcionarios_setores_funcoes_attributes: %i[
      id
      r_setor_funcao_id
      principal
      data_inicio
      data_fim
      ativo
      _destroy
    ] }
  ].freeze

  before_action :set_r_funcionario, only: %i[show update destroy]

  def index
    query = scoped_r_funcionarios.includes(index_associations).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: RFuncionarioBlueprint)
  end

  def show
    render ResponseService.success(data: @r_funcionario, message: "Funcionario encontrado com sucesso", blueprint: RFuncionarioBlueprint)
  end

  def create
    attributes = enforce_tenant_attribute!(r_funcionario_params.to_h.deep_symbolize_keys)
    return if performed?

    result = RFuncionarios::CreateService.call(params: attributes)
    render ResponseService.handle_service_result(result, blueprint: RFuncionarioBlueprint)
  end

  def update
    attributes = enforce_tenant_attribute!(r_funcionario_params.to_h.deep_symbolize_keys)
    return if performed?

    result = RFuncionarios::UpdateService.call(r_funcionario: @r_funcionario, params: attributes)
    render ResponseService.handle_service_result(result, blueprint: RFuncionarioBlueprint)
  end

  def destroy
    result = RFuncionarios::DestroyService.call(r_funcionario: @r_funcionario)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_r_funcionario
    @r_funcionario = scoped_r_funcionarios.find(params[:id])
  end

  def index_associations
    [
      :g_pessoa,
      :g_unidade_gestora,
      :r_tipo_vinculo,
      { r_funcionarios_especialidades: :r_especialidade },
      { r_funcionarios_setores_funcoes: { r_setor_funcao: [ :r_setor, { r_funcao: { r_funcoes_perfis: :u_perfil } } ] } }
    ]
  end

  def scoped_r_funcionarios
    tenant_scope(RFuncionario.all)
  end

  def r_funcionario_params
    params.require(:r_funcionario).permit(*PERMITTED_ATTRIBUTES)
  end
end
