# frozen_string_literal: true

class CreateUPerfisTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :u_perfis_templates do |t|
        t.references :u_perfil, foreign_key: true
        t.references :u_template, foreign_key: true
        t.boolean :principal
        t.boolean :ativo
        t.string :created_by
        t.string :updated_by
        t.datetime :deleted_at
        t.timestamps
    end

    add_index :u_perfis_templates, :deleted_at
  end
end
