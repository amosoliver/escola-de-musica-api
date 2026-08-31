# frozen_string_literal: true

class Api::V1::MeuUsuarioController < ApplicationController
  def show
    render ResponseService.success(
      data: MeuUsuario::BuildService.call(user: current_user),
      message: "Meu usuario carregado com sucesso"
    )
  end
end
