# frozen_string_literal: true

class CreateGUnidadesGestoras < ActiveRecord::Migration[8.1]
  def change
    create_table :g_unidades_gestoras do |t|
        t.references :g_unidade_gestora, foreign_key: { to_table: :g_unidades_gestoras }
        t.string :tipo_unidade
        t.string :nome
        t.string :razao_social
        t.string :nome_fantasia
        t.string :cnpj
        t.string :logo
        t.string :telefone
        t.string :whatsapp
        t.string :email
        t.string :site
        t.string :responsavel_nome
        t.string :status
        t.jsonb :identidade_visual
        t.string :created_by
        t.string :updated_by
        t.datetime :deleted_at
        t.timestamps
    end

    add_index :g_unidades_gestoras, :deleted_at
  end
end
