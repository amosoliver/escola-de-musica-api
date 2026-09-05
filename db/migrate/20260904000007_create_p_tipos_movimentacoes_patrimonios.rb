# frozen_string_literal: true

class CreatePTiposMovimentacoesPatrimonios < ActiveRecord::Migration[8.1]
  def up
    create_table :p_tipos_movimentacoes_patrimonios do |t|
      t.string :codigo, null: false
      t.string :descricao, null: false
      t.boolean :destino_interno, null: false, default: false
      t.boolean :destino_externo, null: false, default: false
      t.boolean :movimentacao_definitiva, null: false, default: false
      t.boolean :ativo, null: false, default: true
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    add_check_constraint :p_tipos_movimentacoes_patrimonios, "NOT (destino_interno AND destino_externo)", name: "p_tipos_movimentacoes_destino_exclusivo"
    add_index :p_tipos_movimentacoes_patrimonios, :deleted_at
    add_index :p_tipos_movimentacoes_patrimonios, :codigo, unique: true, where: "deleted_at IS NULL"
    add_index :p_tipos_movimentacoes_patrimonios, :descricao, unique: true, where: "deleted_at IS NULL"
    populate_referencial("tipos_movimentacoes")
  end

  def down
    drop_table :p_tipos_movimentacoes_patrimonios
  end

  private

  def populate_referencial(task)
    Rails.application.load_tasks unless Rake::Task.task_defined?("patrimonio:referenciais:#{task}")
    Rake::Task["patrimonio:referenciais:#{task}"].reenable
    Rake::Task["patrimonio:referenciais:#{task}"].invoke
  end
end
