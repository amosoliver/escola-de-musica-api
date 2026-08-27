# frozen_string_literal: true

class AddGeographicReferenceTablesAndLinks < ActiveRecord::Migration[8.1]
  def change
    create_table :g_estados do |t|
      t.string :descricao
      t.references :g_pais, null: false, foreign_key: true
      t.string :uf
      t.string :codigo_ibge
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :g_estados, :deleted_at
    add_index :g_estados, :codigo_ibge, unique: true

    add_reference :g_cidades, :g_estado, foreign_key: true

    add_column :g_bairros, :codigo_ibge, :string
    add_index :g_bairros, :codigo_ibge
  end
end
