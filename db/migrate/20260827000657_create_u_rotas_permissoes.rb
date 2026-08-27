# frozen_string_literal: true

class CreateURotasPermissoes < ActiveRecord::Migration[8.1]
  def change
    create_table :u_rotas_permissoes do |t|
        t.references :u_rota, foreign_key: true
        t.references :u_permissao, foreign_key: true
        t.string :created_by
        t.string :updated_by
        t.datetime :deleted_at
        t.timestamps
    end

    add_index :u_rotas_permissoes, :deleted_at
  end
end
