# frozen_string_literal: true

class CreatePTiposManutencoesPatrimonios < ActiveRecord::Migration[8.1]
  def up
    create_table :p_tipos_manutencoes_patrimonios do |t|
      t.string :codigo, null: false
      t.string :descricao, null: false
      t.boolean :ativo, null: false, default: true
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :p_tipos_manutencoes_patrimonios, :deleted_at
    add_index :p_tipos_manutencoes_patrimonios, :codigo, unique: true, where: "deleted_at IS NULL"
    add_index :p_tipos_manutencoes_patrimonios, :descricao, unique: true, where: "deleted_at IS NULL"
    populate_referencial("tipos_manutencoes")
  end

  def down
    drop_table :p_tipos_manutencoes_patrimonios
  end

  private

  def populate_referencial(task)
    Rails.application.load_tasks unless Rake::Task.task_defined?("patrimonio:referenciais:#{task}")
    Rake::Task["patrimonio:referenciais:#{task}"].reenable
    Rake::Task["patrimonio:referenciais:#{task}"].invoke
  end
end
