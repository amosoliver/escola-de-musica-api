# frozen_string_literal: true

class CreateUTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :u_templates do |t|
        t.string :descricao
        t.string :chave
        t.string :componente_layout
        t.jsonb :configuracao
        t.boolean :ativo
        t.string :created_by
        t.string :updated_by
        t.datetime :deleted_at
        t.timestamps
    end

    add_index :u_templates, :deleted_at
  end
end
