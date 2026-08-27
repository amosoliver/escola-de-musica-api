# frozen_string_literal: true

class CreateUSidebars < ActiveRecord::Migration[8.1]
  def change
    create_table :u_sidebars do |t|
        t.references :u_template, foreign_key: true
        t.string :descricao
        t.string :chave
        t.string :posicao
        t.boolean :ativo
        t.string :created_by
        t.string :updated_by
        t.datetime :deleted_at
        t.timestamps
    end

    add_index :u_sidebars, :deleted_at
  end
end
