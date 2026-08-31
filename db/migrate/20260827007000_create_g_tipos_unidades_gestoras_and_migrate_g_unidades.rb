# frozen_string_literal: true

class CreateGTiposUnidadesGestorasAndMigrateGUnidades < ActiveRecord::Migration[8.1]
  def up
    create_table :g_tipos_unidades_gestoras, if_not_exists: true do |t|
      t.string :codigo, null: false
      t.string :descricao, null: false
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :g_tipos_unidades_gestoras, :codigo, unique: true, if_not_exists: true
    add_index :g_tipos_unidades_gestoras, :descricao, unique: true, if_not_exists: true
    add_index :g_tipos_unidades_gestoras, :deleted_at, if_not_exists: true

    add_reference :g_unidades_gestoras,
                  :g_tipo_unidade_gestora,
                  foreign_key: true,
                  index: true,
                  if_not_exists: true
  end

  def down
    remove_reference :g_unidades_gestoras, :g_tipo_unidade_gestora, foreign_key: true, if_exists: true

    drop_table :g_tipos_unidades_gestoras, if_exists: true
  end
end
