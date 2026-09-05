# frozen_string_literal: true

class CreatePEmprestimos < ActiveRecord::Migration[8.1]
  def change
    create_table :p_emprestimos do |t|
      t.references :g_unidade_gestora, null: false, foreign_key: { to_table: :g_unidades_gestoras }
      t.references :g_pessoa, null: false, foreign_key: { to_table: :g_pessoas }
      t.references :p_status_emprestimo_patrimonio, null: false, foreign_key: { to_table: :p_status_emprestimos_patrimonios }
      t.references :r_funcionario_entrega, null: false, foreign_key: { to_table: :r_funcionarios }
      t.string :numero_emprestimo, null: false
      t.datetime :data_emprestimo, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :data_prevista_devolucao
      t.text :observacao
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :p_emprestimos, :deleted_at
    add_index :p_emprestimos, [ :g_unidade_gestora_id, :numero_emprestimo ], unique: true, where: "deleted_at IS NULL", name: "idx_p_emprestimos_unidade_numero"
    add_index :p_emprestimos, :data_prevista_devolucao
  end
end
