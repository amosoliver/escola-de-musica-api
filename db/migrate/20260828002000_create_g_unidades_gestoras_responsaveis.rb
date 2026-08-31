# frozen_string_literal: true

class CreateGUnidadesGestorasResponsaveis < ActiveRecord::Migration[8.1]
  def up
    create_table :g_unidades_gestoras_responsaveis, if_not_exists: true do |t|
      t.references :g_unidade_gestora, null: false, foreign_key: { to_table: :g_unidades_gestoras }
      t.references :g_pessoa, null: false, foreign_key: { to_table: :g_pessoas }
      t.references :r_funcao, foreign_key: { to_table: :r_funcoes }
      t.references :u_perfil, foreign_key: { to_table: :u_perfis }
      t.boolean :principal, null: false, default: true
      t.date :data_inicio
      t.date :data_fim
      t.boolean :ativo, null: false, default: true
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :g_unidades_gestoras_responsaveis, :deleted_at, if_not_exists: true
    add_index :g_unidades_gestoras_responsaveis,
              [ :g_unidade_gestora_id, :g_pessoa_id ],
              unique: true,
              where: "deleted_at IS NULL",
              name: "idx_g_ug_responsaveis_on_unidade_pessoa_unique",
              if_not_exists: true
    add_index :g_unidades_gestoras_responsaveis,
              :g_unidade_gestora_id,
              unique: true,
              where: "principal = TRUE AND ativo = TRUE AND deleted_at IS NULL",
              name: "idx_g_ug_responsaveis_principal_unique",
              if_not_exists: true
  end

  def down
    drop_table :g_unidades_gestoras_responsaveis, if_exists: true
  end
end
