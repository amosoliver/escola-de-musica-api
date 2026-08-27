# frozen_string_literal: true

class CreateUPermissoes < ActiveRecord::Migration[8.1]
  def change
    create_table :u_permissoes do |t|
        t.string :descricao
        t.string :codigo
        t.string :modulo
        t.string :acao
        t.boolean :ativo
        t.string :created_by
        t.string :updated_by
        t.datetime :deleted_at
        t.timestamps
    end

    add_index :u_permissoes, :deleted_at
  end
end
