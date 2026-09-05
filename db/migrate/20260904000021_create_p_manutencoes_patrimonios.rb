# frozen_string_literal: true

class CreatePManutencoesPatrimonios < ActiveRecord::Migration[8.1]
  def change
    create_table :p_manutencoes_patrimonios do |t|
      t.references :g_unidade_gestora, null: false, foreign_key: { to_table: :g_unidades_gestoras }
      t.references :p_patrimonio, null: false, foreign_key: { to_table: :p_patrimonios }
      t.references :p_tipo_manutencao_patrimonio, null: false, foreign_key: { to_table: :p_tipos_manutencoes_patrimonios }
      t.references :p_status_manutencao_patrimonio, null: false, foreign_key: { to_table: :p_status_manutencoes_patrimonios }
      t.references :r_funcionario_solicitante, foreign_key: { to_table: :r_funcionarios }
      t.references :p_destino_externo, foreign_key: { to_table: :p_destinos_externos }
      t.datetime :data_solicitacao, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :data_inicio
      t.datetime :data_prevista
      t.datetime :data_conclusao
      t.text :descricao_problema, null: false
      t.text :descricao_servico
      t.decimal :valor_estimado, precision: 15, scale: 2
      t.decimal :valor_realizado, precision: 15, scale: 2
      t.text :observacao
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :p_manutencoes_patrimonios, :deleted_at
    add_index :p_manutencoes_patrimonios, :data_prevista
  end
end
