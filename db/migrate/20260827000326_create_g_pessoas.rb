# frozen_string_literal: true

class CreateGPessoas < ActiveRecord::Migration[8.1]
  def change
    create_table :g_pessoas do |t|
        t.string :nome
        t.string :nome_social
        t.string :cpf
        t.date :data_nascimento
        t.references :g_sexo, foreign_key: true
        t.string :email
        t.string :telefone
        t.string :whatsapp
        t.string :foto
        t.string :cep
        t.string :logradouro
        t.string :numero
        t.string :bairro
        t.string :cidade
        t.string :uf
        t.string :created_by
        t.string :updated_by
        t.datetime :deleted_at
        t.timestamps
    end

    add_index :g_pessoas, :deleted_at
  end
end
