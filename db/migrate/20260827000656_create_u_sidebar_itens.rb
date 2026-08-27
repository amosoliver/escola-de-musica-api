# frozen_string_literal: true

class CreateUSidebarItens < ActiveRecord::Migration[8.1]
  def change
    create_table :u_sidebar_itens do |t|
        t.references :u_sidebar, foreign_key: true
        t.references :u_sidebar_item_pai, foreign_key: { to_table: :u_sidebar_itens }
        t.references :u_rota, foreign_key: true
        t.string :descricao
        t.string :icone
        t.string :tipo
        t.integer :ordem
        t.boolean :expandido_padrao
        t.boolean :ativo
        t.string :created_by
        t.string :updated_by
        t.datetime :deleted_at
        t.timestamps
    end

    add_index :u_sidebar_itens, :deleted_at
  end
end
