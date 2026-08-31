# frozen_string_literal: true

class AddGUnidadeGestoraToEEstudantes < ActiveRecord::Migration[8.1]
  def up
    add_reference :e_estudantes,
                  :g_unidade_gestora,
                  foreign_key: { to_table: :g_unidades_gestoras },
                  if_not_exists: true

    remove_index :e_estudantes, :registro_aluno if index_exists?(:e_estudantes, :registro_aluno)

    add_index :e_estudantes,
              [ :g_unidade_gestora_id, :registro_aluno ],
              unique: true,
              where: "deleted_at IS NULL",
              name: "idx_e_estudantes_on_unidade_registro_unique",
              if_not_exists: true
  end

  def down
    remove_index :e_estudantes, name: "idx_e_estudantes_on_unidade_registro_unique", if_exists: true
    add_index :e_estudantes, :registro_aluno, unique: true, where: "deleted_at IS NULL", if_not_exists: true
    remove_reference :e_estudantes, :g_unidade_gestora, foreign_key: true, if_exists: true
  end
end
