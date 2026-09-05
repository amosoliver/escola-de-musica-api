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

ActiveRecord::Schema[8.1].define(version: 2026_09_05_000003) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "e_estudantes", force: :cascade do |t|
    t.boolean "acessa_portal", default: false, null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.boolean "emancipado", default: false, null: false
    t.bigint "g_pessoa_id", null: false
    t.bigint "g_unidade_gestora_id"
    t.boolean "proprio_responsavel", default: false, null: false
    t.string "registro_aluno", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_e_estudantes_on_deleted_at"
    t.index ["g_pessoa_id"], name: "index_e_estudantes_on_g_pessoa_id", unique: true, where: "(deleted_at IS NULL)"
    t.index ["g_unidade_gestora_id", "registro_aluno"], name: "idx_e_estudantes_on_unidade_registro_unique", unique: true, where: "(deleted_at IS NULL)"
    t.index ["g_unidade_gestora_id"], name: "index_e_estudantes_on_g_unidade_gestora_id"
  end

  create_table "e_estudantes_responsaveis", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.boolean "autorizado_buscar", default: false, null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.date "data_fim"
    t.date "data_inicio"
    t.datetime "deleted_at"
    t.bigint "e_estudante_id", null: false
    t.bigint "e_responsavel_id", null: false
    t.bigint "g_parentesco_id", null: false
    t.string "parentesco_outro"
    t.boolean "responsavel_financeiro", default: false, null: false
    t.boolean "responsavel_principal", default: false, null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_e_estudantes_responsaveis_on_deleted_at"
    t.index ["e_estudante_id", "e_responsavel_id", "g_parentesco_id"], name: "idx_e_estudantes_responsaveis_unique", unique: true, where: "(deleted_at IS NULL)"
    t.index ["e_estudante_id"], name: "index_e_estudantes_responsaveis_on_e_estudante_id"
    t.index ["e_responsavel_id"], name: "index_e_estudantes_responsaveis_on_e_responsavel_id"
    t.index ["g_parentesco_id"], name: "index_e_estudantes_responsaveis_on_g_parentesco_id"
  end

  create_table "e_responsaveis", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.bigint "g_pessoa_id", null: false
    t.bigint "g_unidade_gestora_id"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_e_responsaveis_on_deleted_at"
    t.index ["g_unidade_gestora_id", "g_pessoa_id"], name: "idx_e_responsaveis_on_unidade_pessoa_unique", unique: true, where: "(deleted_at IS NULL)"
    t.index ["g_unidade_gestora_id"], name: "index_e_responsaveis_on_g_unidade_gestora_id"
  end

  create_table "e_saudes_estudantes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.bigint "e_estudante_id", null: false
    t.text "observacoes_gerais"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_e_saudes_estudantes_on_deleted_at"
    t.index ["e_estudante_id"], name: "idx_e_saudes_estudantes_on_estudante_unique", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "e_saudes_estudantes_alergias", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.bigint "e_saude_estudante_id", null: false
    t.bigint "g_alergia_id", null: false
    t.text "observacao"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_e_saudes_estudantes_alergias_on_deleted_at"
    t.index ["e_saude_estudante_id", "g_alergia_id"], name: "idx_e_saude_estudante_alergia_unique", unique: true, where: "(deleted_at IS NULL)"
    t.index ["e_saude_estudante_id"], name: "index_e_saudes_estudantes_alergias_on_e_saude_estudante_id"
    t.index ["g_alergia_id"], name: "index_e_saudes_estudantes_alergias_on_g_alergia_id"
  end

  create_table "e_saudes_estudantes_necessidades", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.date "data_laudo"
    t.datetime "deleted_at"
    t.bigint "e_saude_estudante_id", null: false
    t.bigint "g_necessidade_especifica_id", null: false
    t.string "laudo_arquivo"
    t.text "observacao"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_e_saudes_estudantes_necessidades_on_deleted_at"
    t.index ["e_saude_estudante_id", "g_necessidade_especifica_id"], name: "idx_e_saude_estudante_necessidade_unique", unique: true, where: "(deleted_at IS NULL)"
    t.index ["e_saude_estudante_id"], name: "index_e_saudes_estudantes_necessidades_on_e_saude_estudante_id"
    t.index ["g_necessidade_especifica_id"], name: "idx_on_g_necessidade_especifica_id_81db84d4d9"
  end

  create_table "g_alergias", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_g_alergias_on_deleted_at"
    t.index ["descricao"], name: "index_g_alergias_on_descricao", unique: true, where: "(deleted_at IS NULL)"
  end

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

  create_table "g_categorias_patrimonios", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["codigo"], name: "index_g_categorias_patrimonios_on_codigo", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_g_categorias_patrimonios_on_deleted_at"
    t.index ["descricao"], name: "index_g_categorias_patrimonios_on_descricao", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "g_cidades", force: :cascade do |t|
    t.string "codigo_ibge"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao"
    t.bigint "g_estado_id"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_g_cidades_on_deleted_at"
    t.index ["g_estado_id"], name: "index_g_cidades_on_g_estado_id"
  end

  create_table "g_classificacoes_instrumentos", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["codigo"], name: "index_g_classificacoes_instrumentos_on_codigo", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_g_classificacoes_instrumentos_on_deleted_at"
    t.index ["descricao"], name: "index_g_classificacoes_instrumentos_on_descricao", unique: true, where: "(deleted_at IS NULL)"
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

  create_table "g_instrumentos", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.bigint "g_tipo_instrumento_id", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["codigo"], name: "index_g_instrumentos_on_codigo", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_g_instrumentos_on_deleted_at"
    t.index ["descricao"], name: "index_g_instrumentos_on_descricao", unique: true, where: "(deleted_at IS NULL)"
    t.index ["g_tipo_instrumento_id"], name: "index_g_instrumentos_on_g_tipo_instrumento_id"
  end

  create_table "g_necessidades_especificas", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_g_necessidades_especificas_on_deleted_at"
    t.index ["descricao"], name: "idx_g_necessidades_especificas_on_descricao_unique", unique: true, where: "(deleted_at IS NULL)"
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

  create_table "g_parentescos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.boolean "permite_outro", default: false, null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_g_parentescos_on_deleted_at"
    t.index ["descricao"], name: "index_g_parentescos_on_descricao", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "g_pessoas", force: :cascade do |t|
    t.string "cep"
    t.string "cpf"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.date "data_nascimento"
    t.datetime "deleted_at"
    t.string "email"
    t.string "foto"
    t.bigint "g_bairro_id"
    t.bigint "g_sexo_id"
    t.string "logradouro"
    t.string "nome"
    t.string "nome_social"
    t.string "numero"
    t.string "telefone"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.string "whatsapp"
    t.index ["cpf"], name: "idx_g_pessoas_cpf_ativo_unique", unique: true, where: "((deleted_at IS NULL) AND (cpf IS NOT NULL))"
    t.index ["deleted_at"], name: "index_g_pessoas_on_deleted_at"
    t.index ["g_bairro_id"], name: "index_g_pessoas_on_g_bairro_id"
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

  create_table "g_tipos_instrumentos", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.bigint "g_classificacao_instrumento_id", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["codigo"], name: "index_g_tipos_instrumentos_on_codigo", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_g_tipos_instrumentos_on_deleted_at"
    t.index ["descricao"], name: "index_g_tipos_instrumentos_on_descricao", unique: true, where: "(deleted_at IS NULL)"
    t.index ["g_classificacao_instrumento_id"], name: "index_g_tipos_instrumentos_on_g_classificacao_instrumento_id"
  end

  create_table "g_tipos_patrimonios", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.bigint "g_categoria_patrimonio_id", null: false
    t.boolean "representa_instrumento", default: false, null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["codigo"], name: "index_g_tipos_patrimonios_on_codigo", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_g_tipos_patrimonios_on_deleted_at"
    t.index ["descricao"], name: "index_g_tipos_patrimonios_on_descricao", unique: true, where: "(deleted_at IS NULL)"
    t.index ["g_categoria_patrimonio_id"], name: "index_g_tipos_patrimonios_on_g_categoria_patrimonio_id"
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

  create_table "g_tipos_unidades_gestoras", force: :cascade do |t|
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["codigo"], name: "index_g_tipos_unidades_gestoras_on_codigo", unique: true
    t.index ["deleted_at"], name: "index_g_tipos_unidades_gestoras_on_deleted_at"
    t.index ["descricao"], name: "index_g_tipos_unidades_gestoras_on_descricao", unique: true
  end

  create_table "g_unidades_gestoras", force: :cascade do |t|
    t.string "cnpj"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "email"
    t.bigint "g_tipo_unidade_gestora_id"
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
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.string "whatsapp"
    t.index ["deleted_at"], name: "index_g_unidades_gestoras_on_deleted_at"
    t.index ["g_tipo_unidade_gestora_id"], name: "index_g_unidades_gestoras_on_g_tipo_unidade_gestora_id"
    t.index ["g_unidade_gestora_id"], name: "index_g_unidades_gestoras_on_g_unidade_gestora_id"
  end

  create_table "g_unidades_gestoras_responsaveis", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.date "data_fim"
    t.date "data_inicio"
    t.datetime "deleted_at"
    t.bigint "g_pessoa_id", null: false
    t.bigint "g_unidade_gestora_id", null: false
    t.boolean "principal", default: true, null: false
    t.bigint "r_funcao_id"
    t.bigint "u_perfil_id"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_g_unidades_gestoras_responsaveis_on_deleted_at"
    t.index ["g_pessoa_id"], name: "index_g_unidades_gestoras_responsaveis_on_g_pessoa_id"
    t.index ["g_unidade_gestora_id", "g_pessoa_id"], name: "idx_g_ug_responsaveis_on_unidade_pessoa_unique", unique: true, where: "(deleted_at IS NULL)"
    t.index ["g_unidade_gestora_id"], name: "idx_g_ug_responsaveis_principal_unique", unique: true, where: "((principal = true) AND (ativo = true) AND (deleted_at IS NULL))"
    t.index ["g_unidade_gestora_id"], name: "index_g_unidades_gestoras_responsaveis_on_g_unidade_gestora_id"
    t.index ["r_funcao_id"], name: "index_g_unidades_gestoras_responsaveis_on_r_funcao_id"
    t.index ["u_perfil_id"], name: "index_g_unidades_gestoras_responsaveis_on_u_perfil_id"
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
    t.bigint "g_unidade_gestora_id"
    t.bigint "i_bloco_id"
    t.decimal "largura"
    t.decimal "metros_quadrados"
    t.boolean "permite_reserva"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_i_ambientes_prediais_on_deleted_at"
    t.index ["g_tipo_ambiente_predial_id"], name: "index_i_ambientes_prediais_on_g_tipo_ambiente_predial_id"
    t.index ["g_unidade_gestora_id"], name: "index_i_ambientes_prediais_on_g_unidade_gestora_id"
    t.index ["i_bloco_id"], name: "index_i_ambientes_prediais_on_i_bloco_id"
  end

  create_table "i_blocos", force: :cascade do |t|
    t.boolean "ativo"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao"
    t.bigint "g_andar_id"
    t.bigint "g_unidade_gestora_id"
    t.bigint "i_predio_id"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_i_blocos_on_deleted_at"
    t.index ["g_andar_id"], name: "index_i_blocos_on_g_andar_id"
    t.index ["g_unidade_gestora_id"], name: "index_i_blocos_on_g_unidade_gestora_id"
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
    t.index ["g_situacao_predio_id"], name: "index_i_predios_on_g_situacao_predio_id"
    t.index ["g_tipo_predio_id"], name: "index_i_predios_on_g_tipo_predio_id"
    t.index ["g_unidade_gestora_id"], name: "index_i_predios_on_g_unidade_gestora_id"
  end

  create_table "p_baixas_patrimonios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "data_baixa", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "deleted_at"
    t.string "documento"
    t.bigint "g_unidade_gestora_id", null: false
    t.text "justificativa", null: false
    t.string "numero_documento"
    t.text "observacao"
    t.bigint "p_destino_externo_id"
    t.bigint "p_movimentacao_patrimonio_id"
    t.bigint "p_patrimonio_id", null: false
    t.bigint "p_tipo_baixa_patrimonio_id", null: false
    t.bigint "r_funcionario_id"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.decimal "valor", precision: 15, scale: 2
    t.index ["data_baixa"], name: "index_p_baixas_patrimonios_on_data_baixa"
    t.index ["deleted_at"], name: "index_p_baixas_patrimonios_on_deleted_at"
    t.index ["g_unidade_gestora_id"], name: "index_p_baixas_patrimonios_on_g_unidade_gestora_id"
    t.index ["p_destino_externo_id"], name: "index_p_baixas_patrimonios_on_p_destino_externo_id"
    t.index ["p_movimentacao_patrimonio_id"], name: "index_p_baixas_patrimonios_on_p_movimentacao_patrimonio_id"
    t.index ["p_patrimonio_id"], name: "idx_p_baixas_patrimonios_unica", unique: true, where: "(deleted_at IS NULL)"
    t.index ["p_patrimonio_id"], name: "index_p_baixas_patrimonios_on_p_patrimonio_id"
    t.index ["p_tipo_baixa_patrimonio_id"], name: "index_p_baixas_patrimonios_on_p_tipo_baixa_patrimonio_id"
    t.index ["r_funcionario_id"], name: "index_p_baixas_patrimonios_on_r_funcionario_id"
  end

  create_table "p_destinos_externos", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.string "cep"
    t.string "complemento"
    t.string "cpf_cnpj"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "email"
    t.bigint "g_bairro_id"
    t.bigint "g_unidade_gestora_id", null: false
    t.string "logradouro"
    t.string "nome", null: false
    t.string "numero"
    t.text "observacao"
    t.string "razao_social"
    t.string "telefone"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["cpf_cnpj"], name: "index_p_destinos_externos_on_cpf_cnpj"
    t.index ["deleted_at"], name: "index_p_destinos_externos_on_deleted_at"
    t.index ["g_bairro_id"], name: "index_p_destinos_externos_on_g_bairro_id"
    t.index ["g_unidade_gestora_id"], name: "index_p_destinos_externos_on_g_unidade_gestora_id"
  end

  create_table "p_devolucoes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "data_devolucao", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "deleted_at"
    t.bigint "g_unidade_gestora_id", null: false
    t.text "observacao"
    t.bigint "p_emprestimo_id", null: false
    t.bigint "r_funcionario_recebimento_id", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["data_devolucao"], name: "index_p_devolucoes_on_data_devolucao"
    t.index ["deleted_at"], name: "index_p_devolucoes_on_deleted_at"
    t.index ["g_unidade_gestora_id"], name: "index_p_devolucoes_on_g_unidade_gestora_id"
    t.index ["p_emprestimo_id"], name: "index_p_devolucoes_on_p_emprestimo_id"
    t.index ["r_funcionario_recebimento_id"], name: "index_p_devolucoes_on_r_funcionario_recebimento_id"
  end

  create_table "p_devolucoes_itens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.text "descricao_avaria"
    t.text "observacao"
    t.bigint "p_devolucao_id", null: false
    t.bigint "p_emprestimo_item_id", null: false
    t.bigint "p_estado_conservacao_patrimonio_id", null: false
    t.boolean "possui_avaria", default: false, null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_p_devolucoes_itens_on_deleted_at"
    t.index ["p_devolucao_id"], name: "index_p_devolucoes_itens_on_p_devolucao_id"
    t.index ["p_emprestimo_item_id"], name: "idx_p_devolucoes_itens_emprestimo_item", unique: true, where: "(deleted_at IS NULL)"
    t.index ["p_emprestimo_item_id"], name: "index_p_devolucoes_itens_on_p_emprestimo_item_id"
    t.index ["p_estado_conservacao_patrimonio_id"], name: "index_p_devolucoes_itens_on_p_estado_conservacao_patrimonio_id"
    t.check_constraint "NOT possui_avaria OR descricao_avaria IS NOT NULL", name: "p_devolucoes_itens_avaria_descricao"
  end

  create_table "p_emprestimos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "data_emprestimo", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "data_prevista_devolucao"
    t.datetime "deleted_at"
    t.bigint "g_pessoa_id", null: false
    t.bigint "g_unidade_gestora_id", null: false
    t.string "numero_emprestimo", null: false
    t.text "observacao"
    t.bigint "p_status_emprestimo_patrimonio_id", null: false
    t.bigint "r_funcionario_entrega_id", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["data_prevista_devolucao"], name: "index_p_emprestimos_on_data_prevista_devolucao"
    t.index ["deleted_at"], name: "index_p_emprestimos_on_deleted_at"
    t.index ["g_pessoa_id"], name: "index_p_emprestimos_on_g_pessoa_id"
    t.index ["g_unidade_gestora_id", "numero_emprestimo"], name: "idx_p_emprestimos_unidade_numero", unique: true, where: "(deleted_at IS NULL)"
    t.index ["g_unidade_gestora_id"], name: "index_p_emprestimos_on_g_unidade_gestora_id"
    t.index ["p_status_emprestimo_patrimonio_id"], name: "index_p_emprestimos_on_p_status_emprestimo_patrimonio_id"
    t.index ["r_funcionario_entrega_id"], name: "index_p_emprestimos_on_r_funcionario_entrega_id"
  end

  create_table "p_emprestimos_itens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.text "observacao_entrega"
    t.bigint "p_emprestimo_id", null: false
    t.bigint "p_estado_conservacao_patrimonio_id", null: false
    t.bigint "p_patrimonio_id", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_p_emprestimos_itens_on_deleted_at"
    t.index ["p_emprestimo_id", "p_patrimonio_id"], name: "idx_p_emprestimos_itens_unico", unique: true, where: "(deleted_at IS NULL)"
    t.index ["p_emprestimo_id"], name: "index_p_emprestimos_itens_on_p_emprestimo_id"
    t.index ["p_estado_conservacao_patrimonio_id"], name: "idx_on_p_estado_conservacao_patrimonio_id_72f96206dc"
    t.index ["p_patrimonio_id"], name: "index_p_emprestimos_itens_on_p_patrimonio_id"
  end

  create_table "p_estados_conservacoes_patrimonios", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.integer "ordem", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["codigo"], name: "index_p_estados_conservacoes_patrimonios_on_codigo", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_p_estados_conservacoes_patrimonios_on_deleted_at"
    t.index ["descricao"], name: "index_p_estados_conservacoes_patrimonios_on_descricao", unique: true, where: "(deleted_at IS NULL)"
    t.index ["ordem"], name: "index_p_estados_conservacoes_patrimonios_on_ordem", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "p_inventarios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "data_fim"
    t.datetime "data_inicio", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.boolean "encerrado", default: false, null: false
    t.bigint "g_unidade_gestora_id", null: false
    t.bigint "i_ambiente_predial_id"
    t.bigint "i_bloco_id"
    t.bigint "i_predio_id"
    t.text "observacao"
    t.bigint "r_funcionario_responsavel_id", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["data_inicio"], name: "index_p_inventarios_on_data_inicio"
    t.index ["deleted_at"], name: "index_p_inventarios_on_deleted_at"
    t.index ["g_unidade_gestora_id"], name: "index_p_inventarios_on_g_unidade_gestora_id"
    t.index ["i_ambiente_predial_id"], name: "index_p_inventarios_on_i_ambiente_predial_id"
    t.index ["i_bloco_id"], name: "index_p_inventarios_on_i_bloco_id"
    t.index ["i_predio_id"], name: "index_p_inventarios_on_i_predio_id"
    t.index ["r_funcionario_responsavel_id"], name: "index_p_inventarios_on_r_funcionario_responsavel_id"
  end

  create_table "p_inventarios_itens", force: :cascade do |t|
    t.datetime "conferido_em"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.boolean "encontrado", default: false, null: false
    t.bigint "i_ambiente_predial_encontrado_id"
    t.boolean "localizacao_divergente", default: false, null: false
    t.text "observacao"
    t.bigint "p_estado_conservacao_patrimonio_id"
    t.bigint "p_inventario_id", null: false
    t.bigint "p_patrimonio_id", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_p_inventarios_itens_on_deleted_at"
    t.index ["i_ambiente_predial_encontrado_id"], name: "index_p_inventarios_itens_on_i_ambiente_predial_encontrado_id"
    t.index ["p_estado_conservacao_patrimonio_id"], name: "idx_on_p_estado_conservacao_patrimonio_id_df316eeeb8"
    t.index ["p_inventario_id", "p_patrimonio_id"], name: "idx_p_inventarios_itens_unico", unique: true, where: "(deleted_at IS NULL)"
    t.index ["p_inventario_id"], name: "index_p_inventarios_itens_on_p_inventario_id"
    t.index ["p_patrimonio_id"], name: "index_p_inventarios_itens_on_p_patrimonio_id"
  end

  create_table "p_manutencoes_patrimonios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "data_conclusao"
    t.datetime "data_inicio"
    t.datetime "data_prevista"
    t.datetime "data_solicitacao", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "deleted_at"
    t.text "descricao_problema", null: false
    t.text "descricao_servico"
    t.bigint "g_unidade_gestora_id", null: false
    t.text "observacao"
    t.bigint "p_destino_externo_id"
    t.bigint "p_patrimonio_id", null: false
    t.bigint "p_status_manutencao_patrimonio_id", null: false
    t.bigint "p_tipo_manutencao_patrimonio_id", null: false
    t.bigint "r_funcionario_solicitante_id"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.decimal "valor_estimado", precision: 15, scale: 2
    t.decimal "valor_realizado", precision: 15, scale: 2
    t.index ["data_prevista"], name: "index_p_manutencoes_patrimonios_on_data_prevista"
    t.index ["deleted_at"], name: "index_p_manutencoes_patrimonios_on_deleted_at"
    t.index ["g_unidade_gestora_id"], name: "index_p_manutencoes_patrimonios_on_g_unidade_gestora_id"
    t.index ["p_destino_externo_id"], name: "index_p_manutencoes_patrimonios_on_p_destino_externo_id"
    t.index ["p_patrimonio_id"], name: "index_p_manutencoes_patrimonios_on_p_patrimonio_id"
    t.index ["p_status_manutencao_patrimonio_id"], name: "idx_on_p_status_manutencao_patrimonio_id_50ae1d1e56"
    t.index ["p_tipo_manutencao_patrimonio_id"], name: "idx_on_p_tipo_manutencao_patrimonio_id_ce441a80ce"
    t.index ["r_funcionario_solicitante_id"], name: "idx_on_r_funcionario_solicitante_id_36d0139f7b"
  end

  create_table "p_movimentacoes_patrimonios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "data_hora", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "deleted_at"
    t.bigint "g_unidade_gestora_id", null: false
    t.bigint "i_ambiente_predial_destino_id"
    t.bigint "i_ambiente_predial_origem_id"
    t.text "motivo"
    t.text "observacao"
    t.bigint "p_destino_externo_id"
    t.bigint "p_patrimonio_id", null: false
    t.bigint "p_tipo_movimentacao_patrimonio_id", null: false
    t.bigint "r_funcionario_id"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["data_hora"], name: "index_p_movimentacoes_patrimonios_on_data_hora"
    t.index ["deleted_at"], name: "index_p_movimentacoes_patrimonios_on_deleted_at"
    t.index ["g_unidade_gestora_id"], name: "index_p_movimentacoes_patrimonios_on_g_unidade_gestora_id"
    t.index ["i_ambiente_predial_destino_id"], name: "idx_on_i_ambiente_predial_destino_id_e56682b135"
    t.index ["i_ambiente_predial_origem_id"], name: "idx_on_i_ambiente_predial_origem_id_fb36a11a11"
    t.index ["p_destino_externo_id"], name: "index_p_movimentacoes_patrimonios_on_p_destino_externo_id"
    t.index ["p_patrimonio_id"], name: "index_p_movimentacoes_patrimonios_on_p_patrimonio_id"
    t.index ["p_tipo_movimentacao_patrimonio_id"], name: "idx_on_p_tipo_movimentacao_patrimonio_id_87bb9aaf2f"
    t.index ["r_funcionario_id"], name: "index_p_movimentacoes_patrimonios_on_r_funcionario_id"
    t.check_constraint "(i_ambiente_predial_destino_id IS NULL) <> (p_destino_externo_id IS NULL)", name: "p_movimentacoes_patrimonios_destino_exclusivo"
  end

  create_table "p_patrimonios", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.string "codigo_barras"
    t.string "codigo_patrimonial", null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.date "data_aquisicao"
    t.date "data_garantia_fim"
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.bigint "g_instrumento_id"
    t.bigint "g_tipo_patrimonio_id"
    t.bigint "g_unidade_gestora_id", null: false
    t.bigint "i_ambiente_predial_id"
    t.string "marca"
    t.string "modelo"
    t.string "numero_serie"
    t.text "observacao"
    t.bigint "p_estado_conservacao_patrimonio_id", null: false
    t.bigint "p_situacao_patrimonio_id", null: false
    t.bigint "p_tipo_aquisicao_patrimonio_id"
    t.string "qr_code"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.decimal "valor_aquisicao", precision: 15, scale: 2
    t.index ["deleted_at"], name: "index_p_patrimonios_on_deleted_at"
    t.index ["g_instrumento_id"], name: "index_p_patrimonios_on_g_instrumento_id"
    t.index ["g_tipo_patrimonio_id"], name: "index_p_patrimonios_on_g_tipo_patrimonio_id"
    t.index ["g_unidade_gestora_id", "codigo_patrimonial"], name: "idx_p_patrimonios_unidade_codigo", unique: true, where: "(deleted_at IS NULL)"
    t.index ["g_unidade_gestora_id"], name: "index_p_patrimonios_on_g_unidade_gestora_id"
    t.index ["i_ambiente_predial_id"], name: "index_p_patrimonios_on_i_ambiente_predial_id"
    t.index ["numero_serie"], name: "index_p_patrimonios_on_numero_serie"
    t.index ["p_estado_conservacao_patrimonio_id"], name: "index_p_patrimonios_on_p_estado_conservacao_patrimonio_id"
    t.index ["p_situacao_patrimonio_id"], name: "index_p_patrimonios_on_p_situacao_patrimonio_id"
    t.index ["p_tipo_aquisicao_patrimonio_id"], name: "index_p_patrimonios_on_p_tipo_aquisicao_patrimonio_id"
  end

  create_table "p_patrimonios_arquivos", force: :cascade do |t|
    t.string "arquivo", null: false
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "nome_original"
    t.text "observacao"
    t.bigint "p_patrimonio_id", null: false
    t.bigint "p_tipo_arquivo_patrimonio_id", null: false
    t.bigint "tamanho_bytes"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_p_patrimonios_arquivos_on_deleted_at"
    t.index ["p_patrimonio_id"], name: "index_p_patrimonios_arquivos_on_p_patrimonio_id"
    t.index ["p_tipo_arquivo_patrimonio_id"], name: "index_p_patrimonios_arquivos_on_p_tipo_arquivo_patrimonio_id"
  end

  create_table "p_patrimonios_responsaveis", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.date "data_fim"
    t.date "data_inicio", default: -> { "CURRENT_DATE" }, null: false
    t.datetime "deleted_at"
    t.bigint "g_pessoa_id", null: false
    t.text "observacao"
    t.bigint "p_patrimonio_id", null: false
    t.boolean "principal", default: true, null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_p_patrimonios_responsaveis_on_deleted_at"
    t.index ["g_pessoa_id"], name: "index_p_patrimonios_responsaveis_on_g_pessoa_id"
    t.index ["p_patrimonio_id", "g_pessoa_id"], name: "idx_p_patrimonios_responsaveis_unico", unique: true, where: "(deleted_at IS NULL)"
    t.index ["p_patrimonio_id"], name: "idx_p_patrimonios_responsaveis_principal", unique: true, where: "(principal AND ativo AND (deleted_at IS NULL))"
    t.index ["p_patrimonio_id"], name: "index_p_patrimonios_responsaveis_on_p_patrimonio_id"
  end

  create_table "p_situacoes_patrimonios", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.boolean "permite_emprestimo", default: false, null: false
    t.boolean "permite_movimentacao", default: true, null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["codigo"], name: "index_p_situacoes_patrimonios_on_codigo", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_p_situacoes_patrimonios_on_deleted_at"
    t.index ["descricao"], name: "index_p_situacoes_patrimonios_on_descricao", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "p_status_emprestimos_patrimonios", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.boolean "finalizador", default: false, null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["codigo"], name: "index_p_status_emprestimos_patrimonios_on_codigo", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_p_status_emprestimos_patrimonios_on_deleted_at"
    t.index ["descricao"], name: "index_p_status_emprestimos_patrimonios_on_descricao", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "p_status_manutencoes_patrimonios", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.boolean "finalizador", default: false, null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["codigo"], name: "index_p_status_manutencoes_patrimonios_on_codigo", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_p_status_manutencoes_patrimonios_on_deleted_at"
    t.index ["descricao"], name: "index_p_status_manutencoes_patrimonios_on_descricao", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "p_tipos_aquisicoes_patrimonios", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["codigo"], name: "index_p_tipos_aquisicoes_patrimonios_on_codigo", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_p_tipos_aquisicoes_patrimonios_on_deleted_at"
    t.index ["descricao"], name: "index_p_tipos_aquisicoes_patrimonios_on_descricao", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "p_tipos_arquivos_patrimonios", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["codigo"], name: "index_p_tipos_arquivos_patrimonios_on_codigo", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_p_tipos_arquivos_patrimonios_on_deleted_at"
    t.index ["descricao"], name: "index_p_tipos_arquivos_patrimonios_on_descricao", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "p_tipos_baixas_patrimonios", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["codigo"], name: "index_p_tipos_baixas_patrimonios_on_codigo", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_p_tipos_baixas_patrimonios_on_deleted_at"
    t.index ["descricao"], name: "index_p_tipos_baixas_patrimonios_on_descricao", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "p_tipos_manutencoes_patrimonios", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["codigo"], name: "index_p_tipos_manutencoes_patrimonios_on_codigo", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_p_tipos_manutencoes_patrimonios_on_deleted_at"
    t.index ["descricao"], name: "index_p_tipos_manutencoes_patrimonios_on_descricao", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "p_tipos_movimentacoes_patrimonios", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.boolean "destino_externo", default: false, null: false
    t.boolean "destino_interno", default: false, null: false
    t.boolean "movimentacao_definitiva", default: false, null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["codigo"], name: "index_p_tipos_movimentacoes_patrimonios_on_codigo", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_p_tipos_movimentacoes_patrimonios_on_deleted_at"
    t.index ["descricao"], name: "index_p_tipos_movimentacoes_patrimonios_on_descricao", unique: true, where: "(deleted_at IS NULL)"
    t.check_constraint "NOT (destino_interno AND destino_externo)", name: "p_tipos_movimentacoes_destino_exclusivo"
  end

  create_table "r_especialidades", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["codigo"], name: "index_r_especialidades_on_codigo", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_r_especialidades_on_deleted_at"
    t.index ["descricao"], name: "index_r_especialidades_on_descricao", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "r_funcionarios", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.date "data_fim"
    t.date "data_inicio"
    t.datetime "deleted_at"
    t.bigint "g_pessoa_id", null: false
    t.bigint "g_unidade_gestora_id", null: false
    t.string "matricula", null: false
    t.bigint "r_tipo_vinculo_id", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_r_funcionarios_on_deleted_at"
    t.index ["g_pessoa_id"], name: "index_r_funcionarios_on_g_pessoa_id", unique: true, where: "(deleted_at IS NULL)"
    t.index ["g_unidade_gestora_id", "matricula"], name: "idx_r_funcionarios_on_unidade_matricula", unique: true, where: "(deleted_at IS NULL)"
    t.index ["g_unidade_gestora_id"], name: "index_r_funcionarios_on_g_unidade_gestora_id"
    t.index ["r_tipo_vinculo_id"], name: "index_r_funcionarios_on_r_tipo_vinculo_id"
  end

  create_table "r_funcionarios_especialidades", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.date "data_fim"
    t.date "data_inicio"
    t.datetime "deleted_at"
    t.boolean "principal", default: false, null: false
    t.bigint "r_especialidade_id", null: false
    t.bigint "r_funcionario_id", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_r_funcionarios_especialidades_on_deleted_at"
    t.index ["r_especialidade_id"], name: "index_r_funcionarios_especialidades_on_r_especialidade_id"
    t.index ["r_funcionario_id", "r_especialidade_id"], name: "idx_r_funcionarios_especialidades_unique", unique: true, where: "(deleted_at IS NULL)"
    t.index ["r_funcionario_id"], name: "idx_r_funcionarios_especialidades_principal_unique", unique: true, where: "((principal = true) AND (ativo = true) AND (deleted_at IS NULL))"
    t.index ["r_funcionario_id"], name: "index_r_funcionarios_especialidades_on_r_funcionario_id"
  end

  create_table "r_funcionarios_funcoes", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.date "data_fim"
    t.date "data_inicio"
    t.datetime "deleted_at"
    t.boolean "principal", default: false, null: false
    t.bigint "r_funcao_id", null: false
    t.bigint "r_funcionario_id", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_r_funcionarios_funcoes_on_deleted_at"
    t.index ["r_funcao_id"], name: "index_r_funcionarios_funcoes_on_r_funcao_id"
    t.index ["r_funcionario_id", "r_funcao_id"], name: "idx_r_funcionarios_funcoes_unique", unique: true, where: "(deleted_at IS NULL)"
    t.index ["r_funcionario_id"], name: "idx_r_funcionarios_funcoes_principal_unique", unique: true, where: "((principal = true) AND (ativo = true) AND (deleted_at IS NULL))"
    t.index ["r_funcionario_id"], name: "index_r_funcionarios_funcoes_on_r_funcionario_id"
  end

  create_table "r_funcionarios_setores_funcoes", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.date "data_fim"
    t.date "data_inicio"
    t.datetime "deleted_at"
    t.boolean "principal", default: false, null: false
    t.bigint "r_funcionario_id", null: false
    t.bigint "r_setor_funcao_id", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_r_funcionarios_setores_funcoes_on_deleted_at"
    t.index ["r_funcionario_id", "r_setor_funcao_id"], name: "idx_r_func_set_funcoes_unique", unique: true, where: "(deleted_at IS NULL)"
    t.index ["r_funcionario_id"], name: "idx_r_func_set_funcoes_principal_unique", unique: true, where: "((principal = true) AND (ativo = true) AND (deleted_at IS NULL))"
    t.index ["r_funcionario_id"], name: "index_r_funcionarios_setores_funcoes_on_r_funcionario_id"
    t.index ["r_setor_funcao_id"], name: "index_r_funcionarios_setores_funcoes_on_r_setor_funcao_id"
  end

  create_table "r_funcoes", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["codigo"], name: "index_r_funcoes_on_codigo", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_r_funcoes_on_deleted_at"
    t.index ["descricao"], name: "index_r_funcoes_on_descricao", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "r_funcoes_perfis", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.boolean "principal", default: false, null: false
    t.bigint "r_funcao_id", null: false
    t.bigint "u_perfil_id", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_r_funcoes_perfis_on_deleted_at"
    t.index ["r_funcao_id", "u_perfil_id"], name: "idx_r_funcoes_perfis_unique", unique: true, where: "(deleted_at IS NULL)"
    t.index ["r_funcao_id"], name: "idx_r_funcoes_perfis_principal_unique", unique: true, where: "((principal = true) AND (ativo = true) AND (deleted_at IS NULL))"
    t.index ["r_funcao_id"], name: "index_r_funcoes_perfis_on_r_funcao_id"
    t.index ["u_perfil_id"], name: "index_r_funcoes_perfis_on_u_perfil_id"
  end

  create_table "r_setores", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.bigint "g_unidade_gestora_id", null: false
    t.integer "ordem"
    t.bigint "r_setor_pai_id"
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_r_setores_on_deleted_at"
    t.index ["g_unidade_gestora_id", "codigo"], name: "idx_r_setores_on_unidade_codigo_unique", unique: true, where: "(deleted_at IS NULL)"
    t.index ["g_unidade_gestora_id", "descricao"], name: "idx_r_setores_on_unidade_descricao_unique", unique: true, where: "(deleted_at IS NULL)"
    t.index ["g_unidade_gestora_id", "r_setor_pai_id", "ordem"], name: "idx_r_setores_on_unidade_pai_ordem"
    t.index ["g_unidade_gestora_id"], name: "index_r_setores_on_g_unidade_gestora_id"
    t.index ["r_setor_pai_id"], name: "index_r_setores_on_r_setor_pai_id"
  end

  create_table "r_setores_funcoes", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.boolean "principal", default: false, null: false
    t.bigint "r_funcao_id", null: false
    t.bigint "r_setor_id", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["deleted_at"], name: "index_r_setores_funcoes_on_deleted_at"
    t.index ["r_funcao_id"], name: "index_r_setores_funcoes_on_r_funcao_id"
    t.index ["r_setor_id", "r_funcao_id"], name: "idx_r_setores_funcoes_unique", unique: true, where: "(deleted_at IS NULL)"
    t.index ["r_setor_id"], name: "idx_r_setores_funcoes_principal_unique", unique: true, where: "((principal = true) AND (ativo = true) AND (deleted_at IS NULL))"
    t.index ["r_setor_id"], name: "index_r_setores_funcoes_on_r_setor_id"
  end

  create_table "r_tipos_vinculos", force: :cascade do |t|
    t.boolean "ativo", default: true, null: false
    t.string "codigo", null: false
    t.datetime "created_at", null: false
    t.string "created_by"
    t.datetime "deleted_at"
    t.string "descricao", null: false
    t.datetime "updated_at", null: false
    t.string "updated_by"
    t.index ["codigo"], name: "index_r_tipos_vinculos_on_codigo", unique: true, where: "(deleted_at IS NULL)"
    t.index ["deleted_at"], name: "index_r_tipos_vinculos_on_deleted_at"
    t.index ["descricao"], name: "index_r_tipos_vinculos_on_descricao", unique: true, where: "(deleted_at IS NULL)"
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
    t.index ["g_pessoa_id"], name: "index_users_on_g_pessoa_id", unique: true
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

  add_foreign_key "e_estudantes", "g_pessoas"
  add_foreign_key "e_estudantes", "g_unidades_gestoras"
  add_foreign_key "e_estudantes_responsaveis", "e_estudantes"
  add_foreign_key "e_estudantes_responsaveis", "e_responsaveis"
  add_foreign_key "e_estudantes_responsaveis", "g_parentescos"
  add_foreign_key "e_responsaveis", "g_pessoas"
  add_foreign_key "e_responsaveis", "g_unidades_gestoras"
  add_foreign_key "e_saudes_estudantes", "e_estudantes"
  add_foreign_key "e_saudes_estudantes_alergias", "e_saudes_estudantes"
  add_foreign_key "e_saudes_estudantes_alergias", "g_alergias"
  add_foreign_key "e_saudes_estudantes_necessidades", "e_saudes_estudantes"
  add_foreign_key "e_saudes_estudantes_necessidades", "g_necessidades_especificas"
  add_foreign_key "g_bairros", "g_cidades"
  add_foreign_key "g_cidades", "g_estados"
  add_foreign_key "g_estados", "g_paises"
  add_foreign_key "g_instrumentos", "g_tipos_instrumentos", column: "g_tipo_instrumento_id"
  add_foreign_key "g_pessoas", "g_bairros"
  add_foreign_key "g_pessoas", "g_sexos"
  add_foreign_key "g_tipos_instrumentos", "g_classificacoes_instrumentos", column: "g_classificacao_instrumento_id"
  add_foreign_key "g_tipos_patrimonios", "g_categorias_patrimonios", column: "g_categoria_patrimonio_id"
  add_foreign_key "g_unidades_gestoras", "g_tipos_unidades_gestoras"
  add_foreign_key "g_unidades_gestoras", "g_unidades_gestoras"
  add_foreign_key "g_unidades_gestoras_responsaveis", "g_pessoas"
  add_foreign_key "g_unidades_gestoras_responsaveis", "g_unidades_gestoras"
  add_foreign_key "g_unidades_gestoras_responsaveis", "r_funcoes"
  add_foreign_key "g_unidades_gestoras_responsaveis", "u_perfis"
  add_foreign_key "i_ambientes_prediais", "g_tipos_ambientes_prediais"
  add_foreign_key "i_ambientes_prediais", "g_unidades_gestoras"
  add_foreign_key "i_ambientes_prediais", "i_blocos"
  add_foreign_key "i_blocos", "g_andares"
  add_foreign_key "i_blocos", "g_unidades_gestoras"
  add_foreign_key "i_blocos", "i_predios"
  add_foreign_key "i_predios", "g_bairros"
  add_foreign_key "i_predios", "g_cidades"
  add_foreign_key "i_predios", "g_situacoes_predios"
  add_foreign_key "i_predios", "g_tipos_predios"
  add_foreign_key "i_predios", "g_unidades_gestoras"
  add_foreign_key "p_baixas_patrimonios", "g_unidades_gestoras"
  add_foreign_key "p_baixas_patrimonios", "p_destinos_externos", column: "p_destino_externo_id"
  add_foreign_key "p_baixas_patrimonios", "p_movimentacoes_patrimonios", column: "p_movimentacao_patrimonio_id"
  add_foreign_key "p_baixas_patrimonios", "p_patrimonios"
  add_foreign_key "p_baixas_patrimonios", "p_tipos_baixas_patrimonios", column: "p_tipo_baixa_patrimonio_id"
  add_foreign_key "p_baixas_patrimonios", "r_funcionarios"
  add_foreign_key "p_destinos_externos", "g_bairros"
  add_foreign_key "p_destinos_externos", "g_unidades_gestoras"
  add_foreign_key "p_devolucoes", "g_unidades_gestoras"
  add_foreign_key "p_devolucoes", "p_emprestimos"
  add_foreign_key "p_devolucoes", "r_funcionarios", column: "r_funcionario_recebimento_id"
  add_foreign_key "p_devolucoes_itens", "p_devolucoes", column: "p_devolucao_id"
  add_foreign_key "p_devolucoes_itens", "p_emprestimos_itens", column: "p_emprestimo_item_id"
  add_foreign_key "p_devolucoes_itens", "p_estados_conservacoes_patrimonios", column: "p_estado_conservacao_patrimonio_id"
  add_foreign_key "p_emprestimos", "g_pessoas"
  add_foreign_key "p_emprestimos", "g_unidades_gestoras"
  add_foreign_key "p_emprestimos", "p_status_emprestimos_patrimonios", column: "p_status_emprestimo_patrimonio_id"
  add_foreign_key "p_emprestimos", "r_funcionarios", column: "r_funcionario_entrega_id"
  add_foreign_key "p_emprestimos_itens", "p_emprestimos"
  add_foreign_key "p_emprestimos_itens", "p_estados_conservacoes_patrimonios", column: "p_estado_conservacao_patrimonio_id"
  add_foreign_key "p_emprestimos_itens", "p_patrimonios"
  add_foreign_key "p_inventarios", "g_unidades_gestoras"
  add_foreign_key "p_inventarios", "i_ambientes_prediais"
  add_foreign_key "p_inventarios", "i_blocos"
  add_foreign_key "p_inventarios", "i_predios"
  add_foreign_key "p_inventarios", "r_funcionarios", column: "r_funcionario_responsavel_id"
  add_foreign_key "p_inventarios_itens", "i_ambientes_prediais", column: "i_ambiente_predial_encontrado_id"
  add_foreign_key "p_inventarios_itens", "p_estados_conservacoes_patrimonios", column: "p_estado_conservacao_patrimonio_id"
  add_foreign_key "p_inventarios_itens", "p_inventarios"
  add_foreign_key "p_inventarios_itens", "p_patrimonios"
  add_foreign_key "p_manutencoes_patrimonios", "g_unidades_gestoras"
  add_foreign_key "p_manutencoes_patrimonios", "p_destinos_externos", column: "p_destino_externo_id"
  add_foreign_key "p_manutencoes_patrimonios", "p_patrimonios"
  add_foreign_key "p_manutencoes_patrimonios", "p_status_manutencoes_patrimonios", column: "p_status_manutencao_patrimonio_id"
  add_foreign_key "p_manutencoes_patrimonios", "p_tipos_manutencoes_patrimonios", column: "p_tipo_manutencao_patrimonio_id"
  add_foreign_key "p_manutencoes_patrimonios", "r_funcionarios", column: "r_funcionario_solicitante_id"
  add_foreign_key "p_movimentacoes_patrimonios", "g_unidades_gestoras"
  add_foreign_key "p_movimentacoes_patrimonios", "i_ambientes_prediais", column: "i_ambiente_predial_destino_id"
  add_foreign_key "p_movimentacoes_patrimonios", "i_ambientes_prediais", column: "i_ambiente_predial_origem_id"
  add_foreign_key "p_movimentacoes_patrimonios", "p_destinos_externos", column: "p_destino_externo_id"
  add_foreign_key "p_movimentacoes_patrimonios", "p_patrimonios"
  add_foreign_key "p_movimentacoes_patrimonios", "p_tipos_movimentacoes_patrimonios", column: "p_tipo_movimentacao_patrimonio_id"
  add_foreign_key "p_movimentacoes_patrimonios", "r_funcionarios"
  add_foreign_key "p_patrimonios", "g_instrumentos"
  add_foreign_key "p_patrimonios", "g_tipos_patrimonios", column: "g_tipo_patrimonio_id"
  add_foreign_key "p_patrimonios", "g_unidades_gestoras"
  add_foreign_key "p_patrimonios", "i_ambientes_prediais"
  add_foreign_key "p_patrimonios", "p_estados_conservacoes_patrimonios", column: "p_estado_conservacao_patrimonio_id"
  add_foreign_key "p_patrimonios", "p_situacoes_patrimonios", column: "p_situacao_patrimonio_id"
  add_foreign_key "p_patrimonios", "p_tipos_aquisicoes_patrimonios", column: "p_tipo_aquisicao_patrimonio_id"
  add_foreign_key "p_patrimonios_arquivos", "p_patrimonios"
  add_foreign_key "p_patrimonios_arquivos", "p_tipos_arquivos_patrimonios", column: "p_tipo_arquivo_patrimonio_id"
  add_foreign_key "p_patrimonios_responsaveis", "g_pessoas"
  add_foreign_key "p_patrimonios_responsaveis", "p_patrimonios"
  add_foreign_key "r_funcionarios", "g_pessoas"
  add_foreign_key "r_funcionarios", "g_unidades_gestoras"
  add_foreign_key "r_funcionarios", "r_tipos_vinculos"
  add_foreign_key "r_funcionarios_especialidades", "r_especialidades"
  add_foreign_key "r_funcionarios_especialidades", "r_funcionarios"
  add_foreign_key "r_funcionarios_funcoes", "r_funcionarios"
  add_foreign_key "r_funcionarios_funcoes", "r_funcoes"
  add_foreign_key "r_funcionarios_setores_funcoes", "r_funcionarios"
  add_foreign_key "r_funcionarios_setores_funcoes", "r_setores_funcoes"
  add_foreign_key "r_funcoes_perfis", "r_funcoes"
  add_foreign_key "r_funcoes_perfis", "u_perfis"
  add_foreign_key "r_setores", "g_unidades_gestoras"
  add_foreign_key "r_setores", "r_setores", column: "r_setor_pai_id"
  add_foreign_key "r_setores_funcoes", "r_funcoes"
  add_foreign_key "r_setores_funcoes", "r_setores"
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
