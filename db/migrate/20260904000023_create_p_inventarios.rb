# frozen_string_literal: true

class CreatePInventarios < ActiveRecord::Migration[8.1]
  def change
    create_table :p_inventarios do |t|
      t.references :g_unidade_gestora, null: false, foreign_key: { to_table: :g_unidades_gestoras }
      t.references :i_predio, foreign_key: { to_table: :i_predios }
      t.references :i_bloco, foreign_key: { to_table: :i_blocos }
      t.references :i_ambiente_predial, foreign_key: { to_table: :i_ambientes_prediais }
      t.references :r_funcionario_responsavel, null: false, foreign_key: { to_table: :r_funcionarios }
      t.string :descricao, null: false
      t.datetime :data_inicio, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.datetime :data_fim
      t.boolean :encerrado, null: false, default: false
      t.text :observacao
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :p_inventarios, :deleted_at
    add_index :p_inventarios, :data_inicio
  end
end
