# frozen_string_literal: true

class CreatePInventariosItens < ActiveRecord::Migration[8.1]
  def change
    create_table :p_inventarios_itens do |t|
      t.references :p_inventario, null: false, foreign_key: { to_table: :p_inventarios }
      t.references :p_patrimonio, null: false, foreign_key: { to_table: :p_patrimonios }
      t.references :p_estado_conservacao_patrimonio, foreign_key: { to_table: :p_estados_conservacoes_patrimonios }
      t.references :i_ambiente_predial_encontrado, foreign_key: { to_table: :i_ambientes_prediais }
      t.boolean :encontrado, null: false, default: false
      t.boolean :localizacao_divergente, null: false, default: false
      t.datetime :conferido_em
      t.text :observacao
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :p_inventarios_itens, :deleted_at
    add_index :p_inventarios_itens, [ :p_inventario_id, :p_patrimonio_id ], unique: true, where: "deleted_at IS NULL", name: "idx_p_inventarios_itens_unico"
  end
end
