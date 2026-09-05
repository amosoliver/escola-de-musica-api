# frozen_string_literal: true

class CreatePDevolucoesItens < ActiveRecord::Migration[8.1]
  def change
    create_table :p_devolucoes_itens do |t|
      t.references :p_devolucao, null: false, foreign_key: { to_table: :p_devolucoes }
      t.references :p_emprestimo_item, null: false, foreign_key: { to_table: :p_emprestimos_itens }
      t.references :p_estado_conservacao_patrimonio, null: false, foreign_key: { to_table: :p_estados_conservacoes_patrimonios }
      t.boolean :possui_avaria, null: false, default: false
      t.text :descricao_avaria
      t.text :observacao
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    add_check_constraint :p_devolucoes_itens, "NOT possui_avaria OR descricao_avaria IS NOT NULL", name: "p_devolucoes_itens_avaria_descricao"
    add_index :p_devolucoes_itens, :deleted_at
    add_index :p_devolucoes_itens, :p_emprestimo_item_id, unique: true, where: "deleted_at IS NULL", name: "idx_p_devolucoes_itens_emprestimo_item"
  end
end
