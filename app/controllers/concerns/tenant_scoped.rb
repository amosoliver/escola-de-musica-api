# frozen_string_literal: true

module TenantScoped
  extend ActiveSupport::Concern

  TENANT_HEADER = "X-Unidade-Gestora-Id"

  private

  def tenant_scope(relation, column: :g_unidade_gestora_id)
    return relation if current_user_admin_plataforma? && selected_g_unidade_gestora_id.blank?

    tenant_id = current_g_unidade_gestora_id
    return relation.none if performed? || tenant_id.blank?

    relation.where(column => tenant_id)
  end

  def current_g_unidade_gestora_id
    return @current_g_unidade_gestora_id if defined?(@current_g_unidade_gestora_id)

    requested_id = selected_g_unidade_gestora_id
    available_ids = current_user_g_unidade_gestora_ids

    @current_g_unidade_gestora_id = if current_user_admin_plataforma?
      requested_id
    elsif requested_id.present?
      if available_ids.include?(requested_id)
        requested_id
      else
        forbidden_tenant_access!
        nil
      end
    elsif available_ids.one?
      available_ids.first
    else
      missing_tenant_context!
      nil
    end
  end

  def authorize_admin_plataforma!
    return if current_user_admin_plataforma?

    render json: {
      success: false,
      message: "Apenas administrador da plataforma pode executar esta operacao",
      errors: [ "Perfil sem permissao para esta operacao" ],
      timestamp: Time.current.iso8601
    }, status: :forbidden
  end

  def enforce_tenant_attribute!(attributes, key: :g_unidade_gestora_id)
    return attributes if current_user_admin_plataforma? && current_g_unidade_gestora_id.blank?
    return attributes if performed?

    tenant_id = current_g_unidade_gestora_id
    return attributes if performed? || tenant_id.blank?

    provided = attributes[key]&.to_i
    if provided.present? && provided != tenant_id
      forbidden_tenant_access!
      return attributes
    end

    attributes.merge(key => tenant_id)
  end

  def selected_g_unidade_gestora_id
    return @selected_g_unidade_gestora_id if defined?(@selected_g_unidade_gestora_id)

    raw_value = request.headers[TENANT_HEADER].presence || params[:g_unidade_gestora_id].presence
    @selected_g_unidade_gestora_id = raw_value.present? ? raw_value.to_i : nil
  end

  def current_user_g_unidade_gestora_ids
    @current_user_g_unidade_gestora_ids ||= current_user.users_perfis.where(ativo: true).pluck(:g_unidade_gestora_id).compact.uniq
  end

  def current_user_admin_plataforma?
    @current_user_admin_plataforma ||= current_user.users_perfis
                                                  .where(ativo: true)
                                                  .joins(:u_perfil)
                                                  .exists?(u_perfis: { codigo: UPerfil::ADMIN_PLATAFORMA })
  end

  def missing_tenant_context!
    render json: {
      success: false,
      message: "Informe a unidade gestora no cabecalho X-Unidade-Gestora-Id",
      errors: [ "Contexto de unidade gestora nao informado" ],
      timestamp: Time.current.iso8601
    }, status: :unprocessable_entity
  end

  def forbidden_tenant_access!
    render json: {
      success: false,
      message: "Acesso nao autorizado para a unidade gestora informada",
      errors: [ "Operacao fora do escopo da unidade gestora do usuario" ],
      timestamp: Time.current.iso8601
    }, status: :forbidden
  end
end
