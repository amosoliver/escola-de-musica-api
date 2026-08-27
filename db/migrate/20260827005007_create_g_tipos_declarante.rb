# frozen_string_literal: true

class CreateCeTiposDeclarante < ActiveRecord::Migration[8.1]
  def change
    create_table :ce_tipos_declarante do |t|
      t.string :descricao, null: false
      t.integer :ordem, null: false
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :ce_tipos_declarante, :deleted_at
    add_index :ce_tipos_declarante, :ordem, unique: true, where: "deleted_at IS NULL"
    add_index :ce_tipos_declarante, :descricao, unique: true, where: "deleted_at IS NULL"
  end
end
