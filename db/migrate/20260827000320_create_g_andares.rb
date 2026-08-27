# frozen_string_literal: true

class CreateGAndares < ActiveRecord::Migration[8.1]
  def change
    create_table :g_andares do |t|
        t.string :descricao
        t.integer :ordem
        t.string :created_by
        t.string :updated_by
        t.datetime :deleted_at
        t.timestamps
    end

    add_index :g_andares, :deleted_at
  end
end
