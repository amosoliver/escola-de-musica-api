# frozen_string_literal: true

class CreateURotas < ActiveRecord::Migration[8.1]
  def change
    create_table :u_rotas do |t|
        t.string :descricao
        t.string :nome_rota
        t.string :path
        t.string :componente
        t.string :metodo
        t.boolean :requer_autorizacao
        t.boolean :ativo
        t.string :created_by
        t.string :updated_by
        t.datetime :deleted_at
        t.timestamps
    end

    add_index :u_rotas, :deleted_at
  end
end
