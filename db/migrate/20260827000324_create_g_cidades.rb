# frozen_string_literal: true

class CreateGCidades < ActiveRecord::Migration[8.1]
  def change
    create_table :g_cidades do |t|
        t.references :g_pais, foreign_key: true
        t.string :descricao
        t.string :uf
        t.string :codigo_ibge
        t.string :created_by
        t.string :updated_by
        t.datetime :deleted_at
        t.timestamps
    end

    add_index :g_cidades, :deleted_at
  end
end
