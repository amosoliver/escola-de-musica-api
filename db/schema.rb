# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_27_005006) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "g_andares", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao"
    t.integer "ordem"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_g_andares_on_deleted_at"
  end

  create_table "g_bairros", force: :cascade do |t|
    t.string "codigo_ibge"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao"
    t.bigint "g_cidade_id"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["codigo_ibge"], name: "index_g_bairros_on_codigo_ibge"
    t.index ["deleted_at"], name: "index_g_bairros_on_deleted_at"
    t.index ["g_cidade_id"], name: "index_g_bairros_on_g_cidade_id"
  end

  create_table "g_cidades", force: :cascade do |t|
    t.string "codigo_ibge"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao"
    t.bigint "g_estado_id"
    t.bigint "g_pais_id"
    t.string "uf"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_g_cidades_on_deleted_at"
    t.index ["g_estado_id"], name: "index_g_cidades_on_g_estado_id"
    t.index ["g_pais_id"], name: "index_g_cidades_on_g_pais_id"
  end

  create_table "g_estados", force: :cascade do |t|
    t.string "codigo_ibge"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao"
    t.bigint "g_pais_id", null: false
    t.string "uf"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["codigo_ibge"], name: "index_g_estados_on_codigo_ibge", unique: true
    t.index ["deleted_at"], name: "index_g_estados_on_deleted_at"
    t.index ["g_pais_id"], name: "index_g_estados_on_g_pais_id"
  end

  create_table "g_paises", force: :cascade do |t|
    t.string "codigo_iso"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao"
    t.string "sigla"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_g_paises_on_deleted_at"
  end

  create_table "g_pessoas", force: :cascade do |t|
    t.string "bairro"
    t.string "cep"
    t.string "cidade"
    t.string "cpf"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.date "data_nascimento"
    t.datetime "deleted_at"
    t.string "email"
    t.string "foto"
    t.bigint "g_sexo_id"
    t.string "logradouro"
    t.string "nome"
    t.string "nome_social"
    t.string "numero"
    t.string "telefone"
    t.string "uf"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.string "whatsapp"
    t.index ["deleted_at"], name: "index_g_pessoas_on_deleted_at"
    t.index ["g_sexo_id"], name: "index_g_pessoas_on_g_sexo_id"
  end

  create_table "g_sexos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_g_sexos_on_deleted_at"
  end

  create_table "g_situacoes_predios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_g_situacoes_predios_on_deleted_at"
  end

  create_table "g_tipos_ambientes_prediais", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_g_tipos_ambientes_prediais_on_deleted_at"
  end

  create_table "g_tipos_predios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_g_tipos_predios_on_deleted_at"
  end

  create_table "g_unidades_gestoras", force: :cascade do |t|
    t.string "cnpj"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "email"
    t.bigint "g_unidade_gestora_id"
    t.jsonb "identidade_visual"
    t.string "logo"
    t.string "nome"
    t.string "nome_fantasia"
    t.string "razao_social"
    t.string "responsavel_nome"
    t.string "site"
    t.string "status"
    t.string "telefone"
    t.string "tipo_unidade"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.string "whatsapp"
    t.index ["deleted_at"], name: "index_g_unidades_gestoras_on_deleted_at"
    t.index ["g_unidade_gestora_id"], name: "index_g_unidades_gestoras_on_g_unidade_gestora_id"
  end

  create_table "i_ambientes_prediais", force: :cascade do |t|
    t.boolean "ativo"
    t.integer "capacidade"
    t.decimal "comprimento"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao"
    t.bigint "g_tipo_ambiente_predial_id"
    t.bigint "i_bloco_id"
    t.decimal "largura"
    t.decimal "metros_quadrados"
    t.boolean "permite_reserva"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_i_ambientes_prediais_on_deleted_at"
    t.index ["g_tipo_ambiente_predial_id"], name: "index_i_ambientes_prediais_on_g_tipo_ambiente_predial_id"
    t.index ["i_bloco_id"], name: "index_i_ambientes_prediais_on_i_bloco_id"
  end

  create_table "i_blocos", force: :cascade do |t|
    t.boolean "ativo"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao"
    t.bigint "g_andar_id"
    t.bigint "i_predio_id"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_i_blocos_on_deleted_at"
    t.index ["g_andar_id"], name: "index_i_blocos_on_g_andar_id"
    t.index ["i_predio_id"], name: "index_i_blocos_on_i_predio_id"
  end

  create_table "i_predios", force: :cascade do |t|
    t.boolean "ativo"
    t.string "cep"
    t.string "complemento"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.date "data_fim"
    t.date "data_inicio"
    t.datetime "deleted_at"
    t.string "email_responsavel"
    t.bigint "g_bairro_id"
    t.bigint "g_cidade_id"
    t.bigint "g_pais_id"
    t.bigint "g_situacao_predio_id"
    t.bigint "g_tipo_predio_id"
    t.bigint "g_unidade_gestora_id"
    t.decimal "latitude"
    t.string "logradouro"
    t.decimal "longitude"
    t.string "nome"
    t.string "numero"
    t.boolean "principal"
    t.string "telefone_contato"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_i_predios_on_deleted_at"
    t.index ["g_bairro_id"], name: "index_i_predios_on_g_bairro_id"
    t.index ["g_cidade_id"], name: "index_i_predios_on_g_cidade_id"
    t.index ["g_pais_id"], name: "index_i_predios_on_g_pais_id"
    t.index ["g_situacao_predio_id"], name: "index_i_predios_on_g_situacao_predio_id"
    t.index ["g_tipo_predio_id"], name: "index_i_predios_on_g_tipo_predio_id"
    t.index ["g_unidade_gestora_id"], name: "index_i_predios_on_g_unidade_gestora_id"
  end

  create_table "u_perfis", force: :cascade do |t|
    t.boolean "ativo"
    t.string "codigo"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_u_perfis_on_deleted_at"
  end

  create_table "u_perfis_permissoes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.bigint "u_perfil_id"
    t.bigint "u_permissao_id"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_u_perfis_permissoes_on_deleted_at"
    t.index ["u_perfil_id"], name: "index_u_perfis_permissoes_on_u_perfil_id"
    t.index ["u_permissao_id"], name: "index_u_perfis_permissoes_on_u_permissao_id"
  end

  create_table "u_perfis_templates", force: :cascade do |t|
    t.boolean "ativo"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.boolean "principal"
    t.bigint "u_perfil_id"
    t.bigint "u_template_id"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_u_perfis_templates_on_deleted_at"
    t.index ["u_perfil_id"], name: "index_u_perfis_templates_on_u_perfil_id"
    t.index ["u_template_id"], name: "index_u_perfis_templates_on_u_template_id"
  end

  create_table "u_permissoes", force: :cascade do |t|
    t.string "acao"
    t.boolean "ativo"
    t.string "codigo"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao"
    t.string "modulo"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_u_permissoes_on_deleted_at"
  end

  create_table "u_rotas", force: :cascade do |t|
    t.boolean "ativo"
    t.string "componente"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao"
    t.string "metodo"
    t.string "nome_rota"
    t.string "path"
    t.boolean "requer_autorizacao"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_u_rotas_on_deleted_at"
  end

  create_table "u_rotas_permissoes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.bigint "u_permissao_id"
    t.bigint "u_rota_id"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_u_rotas_permissoes_on_deleted_at"
    t.index ["u_permissao_id"], name: "index_u_rotas_permissoes_on_u_permissao_id"
    t.index ["u_rota_id"], name: "index_u_rotas_permissoes_on_u_rota_id"
  end

  create_table "u_sidebar_itens", force: :cascade do |t|
    t.boolean "ativo"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao"
    t.boolean "expandido_padrao"
    t.string "icone"
    t.integer "ordem"
    t.string "tipo"
    t.bigint "u_rota_id"
    t.bigint "u_sidebar_id"
    t.bigint "u_sidebar_item_pai_id"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_u_sidebar_itens_on_deleted_at"
    t.index ["u_rota_id"], name: "index_u_sidebar_itens_on_u_rota_id"
    t.index ["u_sidebar_id"], name: "index_u_sidebar_itens_on_u_sidebar_id"
    t.index ["u_sidebar_item_pai_id"], name: "index_u_sidebar_itens_on_u_sidebar_item_pai_id"
  end

  create_table "u_sidebars", force: :cascade do |t|
    t.boolean "ativo"
    t.string "chave"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao"
    t.string "posicao"
    t.bigint "u_template_id"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_u_sidebars_on_deleted_at"
    t.index ["u_template_id"], name: "index_u_sidebars_on_u_template_id"
  end

  create_table "u_templates", force: :cascade do |t|
    t.boolean "ativo"
    t.string "chave"
    t.string "componente_layout"
    t.jsonb "configuracao"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_u_templates_on_deleted_at"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "bloqueado"
    t.string "cpf"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "data_bloqueio"
    t.datetime "data_ultimo_acesso"
    t.datetime "deleted_at"
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.bigint "g_pessoa_id"
    t.string "motivo_bloqueio"
    t.boolean "primeiro_acesso"
    t.string "refresh_token"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "tentativas_acesso"
    t.string "token_primeiro_acesso"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["cpf"], name: "index_users_on_cpf", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["g_pessoa_id"], name: "index_users_on_g_pessoa_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_perfis", force: :cascade do |t|
    t.boolean "ativo"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.bigint "g_unidade_gestora_id"
    t.bigint "u_perfil_id"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.bigint "user_id"
    t.index ["deleted_at"], name: "index_users_perfis_on_deleted_at"
    t.index ["g_unidade_gestora_id"], name: "index_users_perfis_on_g_unidade_gestora_id"
    t.index ["u_perfil_id"], name: "index_users_perfis_on_u_perfil_id"
    t.index ["user_id"], name: "index_users_perfis_on_user_id"
  end

  add_foreign_key "g_bairros", "g_cidades"
  add_foreign_key "g_cidades", "g_estados"
  add_foreign_key "g_cidades", "g_paises"
  add_foreign_key "g_estados", "g_paises"
  add_foreign_key "g_pessoas", "g_sexos"
  add_foreign_key "g_unidades_gestoras", "g_unidades_gestoras"
  add_foreign_key "i_ambientes_prediais", "g_tipos_ambientes_prediais"
  add_foreign_key "i_ambientes_prediais", "i_blocos"
  add_foreign_key "i_blocos", "g_andares"
  add_foreign_key "i_blocos", "i_predios"
  add_foreign_key "i_predios", "g_bairros"
  add_foreign_key "i_predios", "g_cidades"
  add_foreign_key "i_predios", "g_paises"
  add_foreign_key "i_predios", "g_situacoes_predios"
  add_foreign_key "i_predios", "g_tipos_predios"
  add_foreign_key "i_predios", "g_unidades_gestoras"
  add_foreign_key "u_perfis_permissoes", "u_perfis"
  add_foreign_key "u_perfis_permissoes", "u_permissoes"
  add_foreign_key "u_perfis_templates", "u_perfis"
  add_foreign_key "u_perfis_templates", "u_templates"
  add_foreign_key "u_rotas_permissoes", "u_permissoes"
  add_foreign_key "u_rotas_permissoes", "u_rotas"
  add_foreign_key "u_sidebar_itens", "u_rotas"
  add_foreign_key "u_sidebar_itens", "u_sidebar_itens", column: "u_sidebar_item_pai_id"
  add_foreign_key "u_sidebar_itens", "u_sidebars"
  add_foreign_key "u_sidebars", "u_templates"
  add_foreign_key "users", "g_pessoas"
  add_foreign_key "users_perfis", "g_unidades_gestoras"
  add_foreign_key "users_perfis", "u_perfis"
  add_foreign_key "users_perfis", "users"
end
