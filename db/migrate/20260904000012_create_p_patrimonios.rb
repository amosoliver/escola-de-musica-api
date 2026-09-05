# frozen_string_literal: true

class CreatePPatrimonios < ActiveRecord::Migration[8.1]
  def change
    create_table :p_patrimonios do |t|
      t.references :g_unidade_gestora, null: false, foreign_key: { to_table: :g_unidades_gestoras }
      t.references :p_situacao_patrimonio, null: false, foreign_key: { to_table: :p_situacoes_patrimonios }
      t.references :p_estado_conservacao_patrimonio, null: false, foreign_key: { to_table: :p_estados_conservacoes_patrimonios }
      t.references :p_tipo_aquisicao_patrimonio, foreign_key: { to_table: :p_tipos_aquisicoes_patrimonios }
      t.references :i_ambiente_predial, foreign_key: { to_table: :i_ambientes_prediais }
      t.string :codigo_patrimonial, null: false
      t.string :descricao, null: false
      t.string :marca
      t.string :modelo
      t.string :numero_serie
      t.date :data_aquisicao
      t.decimal :valor_aquisicao, precision: 15, scale: 2
      t.date :data_garantia_fim
      t.string :codigo_barras
      t.string :qr_code
      t.text :observacao
      t.boolean :ativo, null: false, default: true
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :p_patrimonios, :deleted_at
    add_index :p_patrimonios, [ :g_unidade_gestora_id, :codigo_patrimonial ], unique: true, where: "deleted_at IS NULL", name: "idx_p_patrimonios_unidade_codigo"
    add_index :p_patrimonios, :numero_serie
  end
end
