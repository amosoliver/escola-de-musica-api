# frozen_string_literal: true

class AddUniquePrincipalIndexesToRhSetoresLinks < ActiveRecord::Migration[8.1]
  def up
    add_index :r_setores_funcoes,
              :r_setor_id,
              unique: true,
              where: "principal = TRUE AND ativo = TRUE AND deleted_at IS NULL",
              name: "idx_r_setores_funcoes_principal_unique",
              if_not_exists: true

    add_index :r_funcionarios_setores_funcoes,
              :r_funcionario_id,
              unique: true,
              where: "principal = TRUE AND ativo = TRUE AND deleted_at IS NULL",
              name: "idx_r_func_set_funcoes_principal_unique",
              if_not_exists: true
  end

  def down
    remove_index :r_funcionarios_setores_funcoes, name: "idx_r_func_set_funcoes_principal_unique", if_exists: true
    remove_index :r_setores_funcoes, name: "idx_r_setores_funcoes_principal_unique", if_exists: true
  end
end
