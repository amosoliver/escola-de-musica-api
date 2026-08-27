# frozen_string_literal: true

class CreateGBairros < ActiveRecord::Migration[8.1]
  def change
    create_table :g_bairros do |t|
        t.references :g_cidade, foreign_key: true
        t.string :descricao
        t.string :created_by
        t.string :updated_by
        t.datetime :deleted_at
        t.timestamps
    end

    add_index :g_bairros, :deleted_at
  end
end
