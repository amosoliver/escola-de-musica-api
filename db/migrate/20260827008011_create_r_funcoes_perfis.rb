# frozen_string_literal: true

class CreateRFuncoesPerfis < ActiveRecord::Migration[8.1]
  def up
    create_table :r_funcoes_perfis, if_not_exists: true do |t|
      t.references :r_funcao, null: false, foreign_key: { to_table: :r_funcoes }
      t.references :u_perfil, null: false, foreign_key: { to_table: :u_perfis }
      t.boolean :principal, null: false, default: false
      t.boolean :ativo, null: false, default: true
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :r_funcoes_perfis, :deleted_at, if_not_exists: true
    add_index :r_funcoes_perfis,
              [ :r_funcao_id, :u_perfil_id ],
              unique: true,
              where: "deleted_at IS NULL",
              name: "idx_r_funcoes_perfis_unique",
              if_not_exists: true
  end

  def down
    drop_table :r_funcoes_perfis, if_exists: true
  end
end
