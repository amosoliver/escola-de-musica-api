# frozen_string_literal: true

class CreateUPerfis < ActiveRecord::Migration[8.1]
  def change
    create_table :u_perfis do |t|
        t.string :descricao
        t.string :codigo
        t.boolean :ativo
        t.string :created_by
        t.string :updated_by
        t.datetime :deleted_at
        t.timestamps
    end

    add_index :u_perfis, :deleted_at
  end
end
