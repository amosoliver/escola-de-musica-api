# frozen_string_literal: true

class NormalizeAndIndexGPessoasCpf < ActiveRecord::Migration[8.1]
  INDEX_NAME = "idx_g_pessoas_cpf_ativo_unique"

  def up
    add_index :g_pessoas,
              :cpf,
              unique: true,
              where: "deleted_at IS NULL AND cpf IS NOT NULL",
              name: INDEX_NAME
  end

  def down
    remove_index :g_pessoas, name: INDEX_NAME
  end
end
