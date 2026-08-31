# frozen_string_literal: true

class CreatePessoasFaseDoisReferenciais < ActiveRecord::Migration[8.1]
  def up
    create_table :g_alergias, if_not_exists: true do |t|
      t.string :descricao, null: false
      t.boolean :ativo, null: false, default: true
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :g_alergias, :deleted_at, if_not_exists: true
    add_index :g_alergias, :descricao, unique: true, where: "deleted_at IS NULL", if_not_exists: true

    create_table :g_necessidades_especificas, if_not_exists: true do |t|
      t.string :descricao, null: false
      t.boolean :ativo, null: false, default: true
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :g_necessidades_especificas, :deleted_at, if_not_exists: true
    add_index :g_necessidades_especificas, :descricao, unique: true, where: "deleted_at IS NULL",
              name: "idx_g_necessidades_especificas_on_descricao_unique",
              if_not_exists: true

    create_table :g_parentescos, if_not_exists: true do |t|
      t.string :descricao, null: false
      t.boolean :permite_outro, null: false, default: false
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :g_parentescos, :deleted_at, if_not_exists: true
    add_index :g_parentescos, :descricao, unique: true, where: "deleted_at IS NULL", if_not_exists: true
  end

  def down
    drop_table :g_parentescos, if_exists: true
    drop_table :g_necessidades_especificas, if_exists: true
    drop_table :g_alergias, if_exists: true
  end
end
