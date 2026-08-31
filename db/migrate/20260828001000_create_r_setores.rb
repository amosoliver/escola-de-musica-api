# frozen_string_literal: true

class CreateRSetores < ActiveRecord::Migration[8.1]
  def up
    create_table :r_setores, if_not_exists: true do |t|
      t.references :g_unidade_gestora, null: false, foreign_key: { to_table: :g_unidades_gestoras }
      t.references :r_setor_pai, foreign_key: { to_table: :r_setores }
      t.string :codigo, null: false
      t.string :descricao, null: false
      t.integer :ordem
      t.boolean :ativo, null: false, default: true
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :r_setores, :deleted_at, if_not_exists: true
    add_index :r_setores,
              [ :g_unidade_gestora_id, :codigo ],
              unique: true,
              where: "deleted_at IS NULL",
              name: "idx_r_setores_on_unidade_codigo_unique",
              if_not_exists: true
    add_index :r_setores,
              [ :g_unidade_gestora_id, :descricao ],
              unique: true,
              where: "deleted_at IS NULL",
              name: "idx_r_setores_on_unidade_descricao_unique",
              if_not_exists: true
    add_index :r_setores,
              [ :g_unidade_gestora_id, :r_setor_pai_id, :ordem ],
              name: "idx_r_setores_on_unidade_pai_ordem",
              if_not_exists: true
  end

  def down
    drop_table :r_setores, if_exists: true
  end
end
