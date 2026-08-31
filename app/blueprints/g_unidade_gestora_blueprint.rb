# frozen_string_literal: true

class GUnidadeGestoraBlueprint < ApplicationBlueprint
  identifier :id
  fields :tipo_unidade, :nome, :razao_social, :nome_fantasia, :cnpj, :logo, :telefone, :whatsapp, :email, :site, :responsavel_nome, :status, :identidade_visual
  association :g_unidade_gestora, blueprint: GUnidadeGestoraBlueprint
  association :g_tipo_unidade_gestora, blueprint: GTipoUnidadeGestoraBlueprint
  association :responsavel_principal, blueprint: GUnidadeGestoraResponsavelBlueprint
end
