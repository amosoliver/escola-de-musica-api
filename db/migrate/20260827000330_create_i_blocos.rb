# frozen_string_literal: true

class CreateIBlocos < ActiveRecord::Migration[8.1]
  def change
    create_table :i_blocos do |t|
        t.references :i_predio, foreign_key: true
        t.references :g_andar, foreign_key: true
        t.string :descricao
        t.boolean :ativo
        t.string :created_by
        t.string :updated_by
        t.datetime :deleted_at
        t.timestamps
    end

    add_index :i_blocos, :deleted_at
  end
end
