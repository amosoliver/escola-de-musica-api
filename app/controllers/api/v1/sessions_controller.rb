# frozen_string_literal: true

class Api::V1::SessionsController < ApplicationController
  skip_before_action :authenticate_request!, only: %i[create refresh destroy]

  def create
    result = Auth::LoginService.call(login: params[:login], password: params[:password])
    render ResponseService.handle_service_result(result)
  end

  def refresh
    result = Auth::RefreshService.call(refresh_token: params[:refresh_token])
    render ResponseService.handle_service_result(result)
  end

  def destroy
    Auth::LogoutService.call(refresh_token: params[:refresh_token])
    render ResponseService.no_content(message: "Logout realizado com sucesso")
  end
end
