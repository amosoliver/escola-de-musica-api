# frozen_string_literal: true

class CreatePMovimentacoesPatrimonios < ActiveRecord::Migration[8.1]
  def change
    create_table :p_movimentacoes_patrimonios do |t|
      t.references :g_unidade_gestora, null: false, foreign_key: { to_table: :g_unidades_gestoras }
      t.references :p_patrimonio, null: false, foreign_key: { to_table: :p_patrimonios }
      t.references :p_tipo_movimentacao_patrimonio, null: false, foreign_key: { to_table: :p_tipos_movimentacoes_patrimonios }
      t.references :i_ambiente_predial_origem, foreign_key: { to_table: :i_ambientes_prediais }
      t.references :i_ambiente_predial_destino, foreign_key: { to_table: :i_ambientes_prediais }
      t.references :p_destino_externo, foreign_key: { to_table: :p_destinos_externos }
      t.references :r_funcionario, foreign_key: { to_table: :r_funcionarios }
      t.datetime :data_hora, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.text :motivo
      t.text :observacao
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    add_check_constraint :p_movimentacoes_patrimonios, "(i_ambiente_predial_destino_id IS NULL) <> (p_destino_externo_id IS NULL)", name: "p_movimentacoes_patrimonios_destino_exclusivo"
    add_index :p_movimentacoes_patrimonios, :deleted_at
    add_index :p_movimentacoes_patrimonios, :data_hora
  end
end
