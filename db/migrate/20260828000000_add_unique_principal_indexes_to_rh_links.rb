# frozen_string_literal: true

class AddUniquePrincipalIndexesToRhLinks < ActiveRecord::Migration[8.1]
  def up
    add_index :r_funcionarios_especialidades,
              :r_funcionario_id,
              unique: true,
              where: "principal = TRUE AND ativo = TRUE AND deleted_at IS NULL",
              name: "idx_r_funcionarios_especialidades_principal_unique",
              if_not_exists: true

    add_index :r_funcionarios_funcoes,
              :r_funcionario_id,
              unique: true,
              where: "principal = TRUE AND ativo = TRUE AND deleted_at IS NULL",
              name: "idx_r_funcionarios_funcoes_principal_unique",
              if_not_exists: true

    add_index :r_funcoes_perfis,
              :r_funcao_id,
              unique: true,
              where: "principal = TRUE AND ativo = TRUE AND deleted_at IS NULL",
              name: "idx_r_funcoes_perfis_principal_unique",
              if_not_exists: true
  end

  def down
    remove_index :r_funcoes_perfis, name: "idx_r_funcoes_perfis_principal_unique", if_exists: true
    remove_index :r_funcionarios_funcoes, name: "idx_r_funcionarios_funcoes_principal_unique", if_exists: true
    remove_index :r_funcionarios_especialidades, name: "idx_r_funcionarios_especialidades_principal_unique",
                 if_exists: true
  end
end
