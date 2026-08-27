# frozen_string_literal: true

class CreateIPredios < ActiveRecord::Migration[8.1]
  def change
    create_table :i_predios do |t|
        t.references :g_unidade_gestora, foreign_key: true
        t.references :g_tipo_predio, foreign_key: true
        t.references :g_situacao_predio, foreign_key: true
        t.string :nome
        t.decimal :latitude
        t.decimal :longitude
        t.string :cep
        t.string :logradouro
        t.references :g_bairro, foreign_key: true
        t.string :numero
        t.string :complemento
        t.references :g_cidade, foreign_key: true
        t.references :g_pais, foreign_key: true
        t.string :telefone_contato
        t.string :email_responsavel
        t.date :data_inicio
        t.date :data_fim
        t.boolean :principal
        t.boolean :ativo
        t.string :created_by
        t.string :updated_by
        t.datetime :deleted_at
        t.timestamps
    end

    add_index :i_predios, :deleted_at
  end
end
