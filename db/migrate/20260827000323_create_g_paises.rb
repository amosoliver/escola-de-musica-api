# frozen_string_literal: true

class CreateGPaises < ActiveRecord::Migration[8.1]
  def change
    create_table :g_paises do |t|
        t.string :descricao
        t.string :sigla
        t.string :codigo_iso
        t.string :created_by
        t.string :updated_by
        t.datetime :deleted_at
        t.timestamps
    end

    add_index :g_paises, :deleted_at
  end
end
