# frozen_string_literal: true

class CreatePEstadosConservacoesPatrimonios < ActiveRecord::Migration[8.1]
  def up
    create_table :p_estados_conservacoes_patrimonios do |t|
      t.string :codigo, null: false
      t.string :descricao, null: false
      t.integer :ordem, null: false
      t.boolean :ativo, null: false, default: true
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :p_estados_conservacoes_patrimonios, :deleted_at
    add_index :p_estados_conservacoes_patrimonios, :codigo, unique: true, where: "deleted_at IS NULL"
    add_index :p_estados_conservacoes_patrimonios, :descricao, unique: true, where: "deleted_at IS NULL"
    add_index :p_estados_conservacoes_patrimonios, :ordem, unique: true, where: "deleted_at IS NULL"
    populate_referencial("estados_conservacao")
  end

  def down
    drop_table :p_estados_conservacoes_patrimonios
  end

  private

  def populate_referencial(task)
    Rails.application.load_tasks unless Rake::Task.task_defined?("patrimonio:referenciais:#{task}")
    Rake::Task["patrimonio:referenciais:#{task}"].reenable
    Rake::Task["patrimonio:referenciais:#{task}"].invoke
  end
end
