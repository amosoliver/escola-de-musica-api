# frozen_string_literal: true

class CreateRFuncionarios < ActiveRecord::Migration[8.1]
  def up
    create_table :r_funcionarios, if_not_exists: true do |t|
      t.references :g_pessoa, null: false, index: false, foreign_key: { to_table: :g_pessoas }
      t.references :g_unidade_gestora, null: false, foreign_key: { to_table: :g_unidades_gestoras }
      t.references :r_tipo_vinculo, null: false, foreign_key: { to_table: :r_tipos_vinculos }
      t.string :matricula, null: false
      t.date :data_inicio
      t.date :data_fim
      t.boolean :ativo, null: false, default: true
      t.string :created_by
      t.string :updated_by
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :r_funcionarios, :deleted_at, if_not_exists: true
    add_index :r_funcionarios, :g_pessoa_id, unique: true, where: "deleted_at IS NULL", if_not_exists: true
    add_index :r_funcionarios,
              [ :g_unidade_gestora_id, :matricula ],
              unique: true,
              where: "deleted_at IS NULL",
              name: "idx_r_funcionarios_on_unidade_matricula",
              if_not_exists: true
  end

  def down
    drop_table :r_funcionarios, if_exists: true
  end
end
