# frozen_string_literal: true

class Api::V1::GPessoasController < ApplicationController
  include Pagy::Backend

  PERMITTED_ATTRIBUTES = [
    :nome,
    :nome_social,
    :cpf,
    :data_nascimento,
    :g_sexo_id,
    :email,
    :telefone,
    :whatsapp,
    :foto,
    :cep,
    :logradouro,
    :numero,
    :bairro,
    :cidade,
    :uf,
  ].freeze

  before_action :set_g_pessoa, only: %i[show update destroy]

  def index
    query = GPessoa.includes(associations_for_index).ransack(params[:q])
    render ResponseService.pagy_index(query.result, params, self, blueprint: GPessoaBlueprint)
  end

  def show
    render ResponseService.success(
      data: @g_pessoa,
      message: "G pessoa encontrado com sucesso",
      blueprint: GPessoaBlueprint
    )
  end

  def create
    result = GPessoas::CreateService.call(params: g_pessoa_params)
    render ResponseService.handle_service_result(result, blueprint: GPessoaBlueprint)
  end

  def update
    result = GPessoas::UpdateService.call(g_pessoa: @g_pessoa, params: g_pessoa_params)
    render ResponseService.handle_service_result(result, blueprint: GPessoaBlueprint)
  end

  def destroy
    result = GPessoas::DestroyService.call(g_pessoa: @g_pessoa)
    render ResponseService.handle_service_result(result)
  end

  private

  def set_g_pessoa
    @g_pessoa = GPessoa.find(params[:id])
  end

  def associations_for_index
    @associations_for_index ||= GPessoa.reflect_on_all_associations(:belongs_to).map(&:name)
  end

  def g_pessoa_params
    params.require(:g_pessoa).permit(*PERMITTED_ATTRIBUTES)
  end
end
