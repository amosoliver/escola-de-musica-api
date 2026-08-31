# frozen_string_literal: true

class AddGUnidadeGestoraToEResponsaveis < ActiveRecord::Migration[8.1]
  def up
    add_reference :e_responsaveis,
                  :g_unidade_gestora,
                  foreign_key: { to_table: :g_unidades_gestoras },
                  if_not_exists: true

    remove_index :e_responsaveis, :g_pessoa_id if index_exists?(:e_responsaveis, :g_pessoa_id)
    add_index :e_responsaveis,
              [ :g_unidade_gestora_id, :g_pessoa_id ],
              unique: true,
              where: "deleted_at IS NULL",
              name: "idx_e_responsaveis_on_unidade_pessoa_unique",
              if_not_exists: true
  end

  def down
    remove_index :e_responsaveis, name: "idx_e_responsaveis_on_unidade_pessoa_unique", if_exists: true
    add_index :e_responsaveis, :g_pessoa_id, unique: true, where: "deleted_at IS NULL", if_not_exists: true
    remove_reference :e_responsaveis, :g_unidade_gestora, foreign_key: true, if_exists: true
  end
end
