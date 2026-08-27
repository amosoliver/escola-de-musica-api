# frozen_string_literal: true

class CreateUsersPerfis < ActiveRecord::Migration[8.1]
  def change
    create_table :users_perfis do |t|
        t.references :user, foreign_key: true
        t.references :u_perfil, foreign_key: true
        t.references :g_unidade_gestora, foreign_key: true
        t.boolean :ativo
        t.string :created_by
        t.string :updated_by
        t.datetime :deleted_at
        t.timestamps
    end

    add_index :users_perfis, :deleted_at
  end
end
