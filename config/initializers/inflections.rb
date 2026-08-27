# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, "\\1en"
#   inflect.singular /^(ox)en/i, "\\1"
#   inflect.irregular "person", "people"
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym "RESTful"
# end

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.irregular "g_unidade_gestora", "g_unidades_gestoras"
  inflect.irregular "i_ambiente_predial", "i_ambientes_prediais"
  inflect.irregular "g_tipo_predio", "g_tipos_predios"
  inflect.irregular "g_situacao_predio", "g_situacoes_predios"
  inflect.irregular "g_andar", "g_andares"
  inflect.irregular "ce_tipo_declarante", "ce_tipos_declarante"
  inflect.irregular "g_tipo_ambiente_predial", "g_tipos_ambientes_prediais"
  inflect.irregular "g_estado", "g_estados"
  inflect.irregular "u_perfil", "u_perfis"
  inflect.irregular "u_permissao", "u_permissoes"
  inflect.irregular "user_perfil", "users_perfis"
  inflect.irregular "u_perfil_permissao", "u_perfis_permissoes"
  inflect.irregular "u_perfil_template", "u_perfis_templates"
  inflect.irregular "g_pais", "g_paises"
  inflect.irregular "u_sidebar_item", "u_sidebar_itens"
  inflect.irregular "u_rota", "u_rotas"
  inflect.irregular "u_rota_permissao", "u_rotas_permissoes"
end
