# frozen_string_literal: true

class CreatePBaixasPatrimonios < ActiveRecord::Migration[8.1]
  def change
    create_table :p_baixas_patrimonios do |t|
      t.references :g_unidade_gestora, null: false, foreign_key: { to_table: :g_unidades_gestoras }
      t.references :p_patrimonio, null: false, foreign_key: { to_table: :p_patrimonios }
      t.references :p_tipo_baixa_patrimonio, null: false, foreign_key: { to_table: :p_tipos_baixas_patrimonios }
      t.references :p_movimentacao_patrimonio, foreign_key: { to_table: :p_movimentacoes_patrimonios }
      t.references :p_destino_externo, foreign_key: { to_table: :p_destinos_externos }
      t.references :r_funcionario, foreign_key: { to_table: :r_funcionarios }
      t.datetime :data_baixa, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.decimal :valor, precision: 15, scale: 2
      t.string :numero_documento
      t.string :documento
      t.text :justificativa, null: false
      t.text :observacao
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :p_baixas_patrimonios, :deleted_at
    add_index :p_baixas_patrimonios, :p_patrimonio_id, unique: true, where: "deleted_at IS NULL", name: "idx_p_baixas_patrimonios_unica"
    add_index :p_baixas_patrimonios, :data_baixa
  end
end
