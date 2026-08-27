# frozen_string_literal: true

class CreateIAmbientesPrediais < ActiveRecord::Migration[8.1]
  def change
    create_table :i_ambientes_prediais do |t|
        t.references :i_bloco, foreign_key: true
        t.references :g_tipo_ambiente_predial, foreign_key: true
        t.string :descricao
        t.decimal :comprimento
        t.decimal :largura
        t.decimal :metros_quadrados
        t.integer :capacidade
        t.boolean :permite_reserva
        t.boolean :ativo
        t.string :created_by
        t.string :updated_by
        t.datetime :deleted_at
        t.timestamps
    end

    add_index :i_ambientes_prediais, :deleted_at
  end
end
