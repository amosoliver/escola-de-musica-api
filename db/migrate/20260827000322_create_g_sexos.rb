# frozen_string_literal: true

class CreateGSexos < ActiveRecord::Migration[8.1]
  def change
    create_table :g_sexos do |t|
        t.string :descricao
        t.string :created_by
        t.string :updated_by
        t.datetime :deleted_at
        t.timestamps
    end

    add_index :g_sexos, :deleted_at
  end
end
