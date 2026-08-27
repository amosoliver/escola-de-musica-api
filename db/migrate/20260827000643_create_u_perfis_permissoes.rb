# frozen_string_literal: true

class CreateUPerfisPermissoes < ActiveRecord::Migration[8.1]
  def change
    create_table :u_perfis_permissoes do |t|
        t.references :u_perfil, foreign_key: true
        t.references :u_permissao, foreign_key: true
        t.string :created_by
        t.string :updated_by
        t.datetime :deleted_at
        t.timestamps
    end

    add_index :u_perfis_permissoes, :deleted_at
  end
end
