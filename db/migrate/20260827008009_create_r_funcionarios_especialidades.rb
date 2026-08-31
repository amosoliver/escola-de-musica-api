# frozen_string_literal: true

class CreateRFuncionariosEspecialidades < ActiveRecord::Migration[8.1]
  def up
    create_table :r_funcionarios_especialidades, if_not_exists: true do |t|
      t.references :r_funcionario, null: false, foreign_key: { to_table: :r_funcionarios }
      t.references :r_especialidade, null: false, foreign_key: { to_table: :r_especialidades }
      t.boolean :principal, null: false, default: false
      t.date :data_inicio
      t.date :data_fim
      t.boolean :ativo, null: false, default: true
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :r_funcionarios_especialidades, :deleted_at, if_not_exists: true
    add_index :r_funcionarios_especialidades,
              [ :r_funcionario_id, :r_especialidade_id ],
              unique: true,
              where: "deleted_at IS NULL",
              name: "idx_r_funcionarios_especialidades_unique",
              if_not_exists: true
  end

  def down
    drop_table :r_funcionarios_especialidades, if_exists: true
  end
end
