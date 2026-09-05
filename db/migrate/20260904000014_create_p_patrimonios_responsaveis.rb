# frozen_string_literal: true

class CreatePPatrimoniosResponsaveis < ActiveRecord::Migration[8.1]
  def change
    create_table :p_patrimonios_responsaveis do |t|
      t.references :p_patrimonio, null: false, foreign_key: { to_table: :p_patrimonios }
      t.references :g_pessoa, null: false, foreign_key: { to_table: :g_pessoas }
      t.boolean :principal, null: false, default: true
      t.date :data_inicio, null: false, default: -> { "CURRENT_DATE" }
      t.date :data_fim
      t.boolean :ativo, null: false, default: true
      t.text :observacao
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :p_patrimonios_responsaveis, :deleted_at
    add_index :p_patrimonios_responsaveis, [ :p_patrimonio_id, :g_pessoa_id ], unique: true, where: "deleted_at IS NULL", name: "idx_p_patrimonios_responsaveis_unico"
    add_index :p_patrimonios_responsaveis, :p_patrimonio_id, unique: true, where: "principal AND ativo AND deleted_at IS NULL", name: "idx_p_patrimonios_responsaveis_principal"
  end
end
