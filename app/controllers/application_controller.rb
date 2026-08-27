class ApplicationController < ActionController::API
  include ApiResponses

  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from StandardError, with: :internal_server_error
  rescue_from ActionDispatch::Http::Parameters::ParseError, with: :handle_parse_error
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  before_action :set_associations

  private

  def set_associations
    model = controller_name.classify.safe_constantize
    @associations = if model.is_a?(Class) && model < ApplicationRecord
      model.reflect_on_all_associations(:belongs_to).map(&:name)
    else
      []
    end
  end

  def record_not_found(exception)
    render json: { success: false, message: "Registro nao encontrado", error: exception.message }, status: :not_found
  end

  def parameter_missing(exception)
    render json: { success: false, message: "Parametro obrigatorio ausente", error: exception.message }, status: :unprocessable_entity
  end

  def internal_server_error(exception)
    render json: { success: false, message: "Erro interno do servidor", error: exception.message }, status: :internal_server_error
  end

  def handle_parse_error(exception)
    render json: {
      success: false,
      message: parse_error_message,
      error: exception.message
    }, status: :bad_request
  end

  def parse_error_message
    return "Parametros invalidos na URL, revise a query string da requisicao." if request.get?
    return "JSON invalido, revise o corpo da requisicao." if request.content_mime_type&.json?

    "Parametros da requisicao invalidos."
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[login password])
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[cpf email password password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[cpf email password password_confirmation current_password])
  end
end
