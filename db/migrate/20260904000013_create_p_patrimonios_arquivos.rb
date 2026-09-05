# frozen_string_literal: true

class CreatePPatrimoniosArquivos < ActiveRecord::Migration[8.1]
  def change
    create_table :p_patrimonios_arquivos do |t|
      t.references :p_patrimonio, null: false, foreign_key: { to_table: :p_patrimonios }
      t.references :p_tipo_arquivo_patrimonio, null: false, foreign_key: { to_table: :p_tipos_arquivos_patrimonios }
      t.string :arquivo, null: false
      t.string :nome_original
      t.string :content_type
      t.bigint :tamanho_bytes
      t.text :observacao
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :p_patrimonios_arquivos, :deleted_at
  end
end
