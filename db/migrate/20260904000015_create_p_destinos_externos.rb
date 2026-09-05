# frozen_string_literal: true

class CreatePDestinosExternos < ActiveRecord::Migration[8.1]
  def change
    create_table :p_destinos_externos do |t|
      t.references :g_unidade_gestora, null: false, foreign_key: { to_table: :g_unidades_gestoras }
      t.references :g_bairro, foreign_key: { to_table: :g_bairros }
      t.string :nome, null: false
      t.string :razao_social
      t.string :cpf_cnpj
      t.string :telefone
      t.string :email
      t.string :cep
      t.string :logradouro
      t.string :numero
      t.string :complemento
      t.text :observacao
      t.boolean :ativo, null: false, default: true
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :p_destinos_externos, :deleted_at
    add_index :p_destinos_externos, :cpf_cnpj
  end
end
