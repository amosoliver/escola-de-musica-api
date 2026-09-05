# frozen_string_literal: true

class CreatePSituacoesPatrimonios < ActiveRecord::Migration[8.1]
  def up
    create_table :p_situacoes_patrimonios do |t|
      t.string :codigo, null: false
      t.string :descricao, null: false
      t.boolean :permite_emprestimo, null: false, default: false
      t.boolean :permite_movimentacao, null: false, default: true
      t.boolean :ativo, null: false, default: true
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :p_situacoes_patrimonios, :deleted_at
    add_index :p_situacoes_patrimonios, :codigo, unique: true, where: "deleted_at IS NULL"
    add_index :p_situacoes_patrimonios, :descricao, unique: true, where: "deleted_at IS NULL"
    populate_referencial("situacoes")
  end

  def down
    drop_table :p_situacoes_patrimonios
  end

  private

  def populate_referencial(task)
    Rails.application.load_tasks unless Rake::Task.task_defined?("patrimonio:referenciais:#{task}")
    Rake::Task["patrimonio:referenciais:#{task}"].reenable
    Rake::Task["patrimonio:referenciais:#{task}"].invoke
  end
end
