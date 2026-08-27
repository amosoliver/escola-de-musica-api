# frozen_string_literal: true

class CreateGTiposAmbientesPrediais < ActiveRecord::Migration[8.1]
  def change
    create_table :g_tipos_ambientes_prediais do |t|
        t.string :descricao
        t.string :created_by
        t.string :updated_by
        t.datetime :deleted_at
        t.timestamps
    end

    add_index :g_tipos_ambientes_prediais, :deleted_at
  end
end
