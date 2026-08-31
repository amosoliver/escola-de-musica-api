# frozen_string_literal: true

class CreateRTiposVinculos < ActiveRecord::Migration[8.1]
  def up
    create_table :r_tipos_vinculos, if_not_exists: true do |t|
      t.string :descricao, null: false
      t.string :codigo, null: false
      t.boolean :ativo, null: false, default: true
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :r_tipos_vinculos, :deleted_at, if_not_exists: true
    add_index :r_tipos_vinculos, :codigo, unique: true, where: "deleted_at IS NULL", if_not_exists: true
    add_index :r_tipos_vinculos, :descricao, unique: true, where: "deleted_at IS NULL", if_not_exists: true
  end

  def down
    drop_table :r_tipos_vinculos, if_exists: true
  end
end
