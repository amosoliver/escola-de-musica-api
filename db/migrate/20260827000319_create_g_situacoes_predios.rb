# frozen_string_literal: true

class CreateGSituacoesPredios < ActiveRecord::Migration[8.1]
  def change
    create_table :g_situacoes_predios do |t|
        t.string :descricao
        t.string :created_by
        t.string :updated_by
        t.datetime :deleted_at
        t.timestamps
    end

    add_index :g_situacoes_predios, :deleted_at
  end
end
