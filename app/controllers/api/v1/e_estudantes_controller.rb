# frozen_string_literal: true

class Api::V1::EEstudantesController < ApplicationController
  include Pagy::Method

  G_PESSOA_ATTRIBUTES = Api::V1::GPessoasController::PERMITTED_ATTRIBUTES - %i[
    password
    password_confirmation
    u_perfil_id
    g_unidade_gestora_id
    ativo
  ]

  PERMITTED_ATTRIBUTES = [
    :g_pessoa_id,
    :atualizar_g_pessoa,
    :g_unidade_gestora_id,
    :registro_aluno,
    :emancipado,
    :proprio_responsavel,
    :acessa_portal,
    { g_pessoa_attributes: G_PESSOA_ATTRIBUTES },
    {
      e_saude_estudante_attributes: [
        :id,
        :observacoes_gerais,
        :_destroy,
        { e_saudes_estudantes_alergias_attributes: %i[id g_alergia_id observacao ativo _destroy] },
        {
          e_saudes_estudantes_necessidades_attributes: %i[
            id
            g_necessidade_especifica_id
            observacao
            laudo_arquivo
            data_laudo
            ativo
            _destroy
          ]
        }
      ]
    },
    {
      e_estudantes_responsaveis_attributes: [
        :id,
        :e_responsavel_id,
        :g_parentesco_id,
        :parentesco_outro,
        :responsavel_principal,
        :responsavel_financeiro,
        :autorizado_buscar,
        :data_inicio,
        :data_fim,
        :ativo,
        :_destroy,
        {
          e_responsavel_attributes: [
            :id,
            :g_pessoa_id,
            :atualizar_g_pessoa,
            :ativo,
            { g_pessoa_attributes: G_PESSOA_ATTRIBUTES }
          ]
        }
      ]
    }
  ].freeze

  before_action :set_e_estudante, only: %i[show update destroy]

  def index
    query = scoped_e_estudantes.includes(index_associations).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: EEstudanteBlueprint)
  end

  def show
    render ResponseService.success(data: @e_estudante, message: "Estudante encontrado com sucesso", blueprint: EEstudanteBlueprint)
  end

  def create
    attributes = enforce_tenant_attribute!(e_estudante_params.to_h.deep_symbolize_keys)
    return if performed?

    result = EEstudantes::CreateService.call(params: attributes)
    render ResponseService.handle_service_result(result, blueprint: EEstudanteBlueprint)
  end

  def update
    attributes = enforce_tenant_attribute!(e_estudante_params.to_h.deep_symbolize_keys)
    return if performed?

    result = EEstudantes::UpdateService.call(
      e_estudante: @e_estudante,
      params: attributes
    )
    render ResponseService.handle_service_result(result, blueprint: EEstudanteBlueprint)
  end

  def destroy
    result = EEstudantes::DestroyService.call(e_estudante: @e_estudante)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_e_estudante
    @e_estudante = scoped_e_estudantes.find(params[:id])
  end

  def index_associations
    [
      :g_unidade_gestora,
      :g_pessoa,
      { e_saude_estudante: [
        { e_saudes_estudantes_alergias: :g_alergia },
        { e_saudes_estudantes_necessidades: :g_necessidade_especifica }
      ] },
      { e_estudantes_responsaveis: [
        :g_parentesco,
        { e_responsavel: :g_pessoa }
      ] }
    ]
  end

  def scoped_e_estudantes
    tenant_scope(EEstudante.all)
  end

  def e_estudante_params
    params.require(:e_estudante).permit(*PERMITTED_ATTRIBUTES)
  end
end
