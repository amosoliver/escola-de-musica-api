# frozen_string_literal: true

class CreateGTiposPatrimonios < ActiveRecord::Migration[8.1]
  def up
    create_table :g_tipos_patrimonios do |t|
      t.references :g_categoria_patrimonio, null: false, foreign_key: { to_table: :g_categorias_patrimonios }
      t.string :codigo, null: false
      t.string :descricao, null: false
      t.boolean :representa_instrumento, null: false, default: false
      t.boolean :ativo, null: false, default: true
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :g_tipos_patrimonios, :deleted_at
    add_index :g_tipos_patrimonios, :codigo, unique: true, where: "deleted_at IS NULL"
    add_index :g_tipos_patrimonios, :descricao, unique: true, where: "deleted_at IS NULL"
    populate_referencial("patrimonio:classificacao:tipos")
  end

  def down
    drop_table :g_tipos_patrimonios
  end

  private

  def populate_referencial(task_name)
    Rails.application.load_tasks unless Rake::Task.task_defined?(task_name)
    Rake::Task[task_name].reenable
    Rake::Task[task_name].invoke
  end
end
