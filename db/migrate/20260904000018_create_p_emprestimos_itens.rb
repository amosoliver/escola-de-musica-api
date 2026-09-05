# frozen_string_literal: true

class CreatePEmprestimosItens < ActiveRecord::Migration[8.1]
  def change
    create_table :p_emprestimos_itens do |t|
      t.references :p_emprestimo, null: false, foreign_key: { to_table: :p_emprestimos }
      t.references :p_patrimonio, null: false, foreign_key: { to_table: :p_patrimonios }
      t.references :p_estado_conservacao_patrimonio, null: false, foreign_key: { to_table: :p_estados_conservacoes_patrimonios }
      t.text :observacao_entrega
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :p_emprestimos_itens, :deleted_at
    add_index :p_emprestimos_itens, [ :p_emprestimo_id, :p_patrimonio_id ], unique: true, where: "deleted_at IS NULL", name: "idx_p_emprestimos_itens_unico"
  end
end
