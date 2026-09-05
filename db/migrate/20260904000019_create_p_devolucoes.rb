# frozen_string_literal: true

class CreatePDevolucoes < ActiveRecord::Migration[8.1]
  def change
    create_table :p_devolucoes do |t|
      t.references :g_unidade_gestora, null: false, foreign_key: { to_table: :g_unidades_gestoras }
      t.references :p_emprestimo, null: false, foreign_key: { to_table: :p_emprestimos }
      t.references :r_funcionario_recebimento, null: false, foreign_key: { to_table: :r_funcionarios }
      t.datetime :data_devolucao, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.text :observacao
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :p_devolucoes, :deleted_at
    add_index :p_devolucoes, :data_devolucao
  end
end
