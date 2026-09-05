# frozen_string_literal: true

class CreateGTiposInstrumentos < ActiveRecord::Migration[8.1]
  def up
    create_table :g_tipos_instrumentos do |t|
      t.references :g_classificacao_instrumento, null: false, foreign_key: { to_table: :g_classificacoes_instrumentos }
      t.string :codigo, null: false
      t.string :descricao, null: false
      t.boolean :ativo, null: false, default: true
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :g_tipos_instrumentos, :deleted_at
    add_index :g_tipos_instrumentos, :codigo, unique: true, where: "deleted_at IS NULL"
    add_index :g_tipos_instrumentos, :descricao, unique: true, where: "deleted_at IS NULL"
    populate_referencial("instrumentos:referenciais:tipos")
  end

  def down
    drop_table :g_tipos_instrumentos
  end

  private

  def populate_referencial(task_name)
    Rails.application.load_tasks unless Rake::Task.task_defined?(task_name)
    Rake::Task[task_name].reenable
    Rake::Task[task_name].invoke
  end
end
