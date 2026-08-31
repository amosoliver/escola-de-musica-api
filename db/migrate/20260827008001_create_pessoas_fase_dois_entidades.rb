# frozen_string_literal: true

class CreatePessoasFaseDoisEntidades < ActiveRecord::Migration[8.1]
  def up
    create_table :e_estudantes, if_not_exists: true do |t|
      t.references :g_pessoa, null: false, index: false, foreign_key: { to_table: :g_pessoas }
      t.string :registro_aluno, null: false
      t.boolean :emancipado, null: false, default: false
      t.boolean :proprio_responsavel, null: false, default: false
      t.boolean :acessa_portal, null: false, default: false
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :e_estudantes, :deleted_at, if_not_exists: true
    add_index :e_estudantes, :registro_aluno, unique: true, where: "deleted_at IS NULL", if_not_exists: true
    add_index :e_estudantes, :g_pessoa_id, unique: true, where: "deleted_at IS NULL", if_not_exists: true

    create_table :e_saudes_estudantes, if_not_exists: true do |t|
      t.references :e_estudante, null: false, index: false, foreign_key: { to_table: :e_estudantes }
      t.text :observacoes_gerais
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :e_saudes_estudantes, :deleted_at, if_not_exists: true
    add_index :e_saudes_estudantes, :e_estudante_id, unique: true, where: "deleted_at IS NULL",
              name: "idx_e_saudes_estudantes_on_estudante_unique",
              if_not_exists: true

    create_table :e_saudes_estudantes_alergias, if_not_exists: true do |t|
      t.references :e_saude_estudante, null: false, foreign_key: { to_table: :e_saudes_estudantes }
      t.references :g_alergia, null: false, foreign_key: { to_table: :g_alergias }
      t.text :observacao
      t.boolean :ativo, null: false, default: true
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :e_saudes_estudantes_alergias, :deleted_at, if_not_exists: true
    add_index :e_saudes_estudantes_alergias, [ :e_saude_estudante_id, :g_alergia_id ],
              unique: true,
              where: "deleted_at IS NULL",
              name: "idx_e_saude_estudante_alergia_unique",
              if_not_exists: true

    create_table :e_saudes_estudantes_necessidades, if_not_exists: true do |t|
      t.references :e_saude_estudante, null: false, foreign_key: { to_table: :e_saudes_estudantes }
      t.references :g_necessidade_especifica, null: false, foreign_key: { to_table: :g_necessidades_especificas }
      t.text :observacao
      t.string :laudo_arquivo
      t.date :data_laudo
      t.boolean :ativo, null: false, default: true
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :e_saudes_estudantes_necessidades, :deleted_at, if_not_exists: true
    add_index :e_saudes_estudantes_necessidades,
              [ :e_saude_estudante_id, :g_necessidade_especifica_id ],
              unique: true,
              where: "deleted_at IS NULL",
              name: "idx_e_saude_estudante_necessidade_unique",
              if_not_exists: true

    create_table :e_responsaveis, if_not_exists: true do |t|
      t.references :g_pessoa, null: false, index: false, foreign_key: { to_table: :g_pessoas }
      t.boolean :ativo, null: false, default: true
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :e_responsaveis, :deleted_at, if_not_exists: true
    add_index :e_responsaveis, :g_pessoa_id, unique: true, where: "deleted_at IS NULL", if_not_exists: true

    create_table :e_estudantes_responsaveis, if_not_exists: true do |t|
      t.references :e_estudante, null: false, foreign_key: { to_table: :e_estudantes }
      t.references :e_responsavel, null: false, foreign_key: { to_table: :e_responsaveis }
      t.references :g_parentesco, null: false, foreign_key: { to_table: :g_parentescos }
      t.string :parentesco_outro
      t.boolean :responsavel_principal, null: false, default: false
      t.boolean :responsavel_financeiro, null: false, default: false
      t.boolean :autorizado_buscar, null: false, default: false
      t.date :data_inicio
      t.date :data_fim
      t.boolean :ativo, null: false, default: true
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :e_estudantes_responsaveis, :deleted_at, if_not_exists: true
    add_index :e_estudantes_responsaveis, [ :e_estudante_id, :e_responsavel_id, :g_parentesco_id ],
              unique: true,
              where: "deleted_at IS NULL",
              name: "idx_e_estudantes_responsaveis_unique",
              if_not_exists: true
  end

  def down
    drop_table :e_estudantes_responsaveis, if_exists: true
    drop_table :e_responsaveis, if_exists: true
    drop_table :e_saudes_estudantes_necessidades, if_exists: true
    drop_table :e_saudes_estudantes_alergias, if_exists: true
    drop_table :e_saudes_estudantes, if_exists: true
    drop_table :e_estudantes, if_exists: true
  end
end
