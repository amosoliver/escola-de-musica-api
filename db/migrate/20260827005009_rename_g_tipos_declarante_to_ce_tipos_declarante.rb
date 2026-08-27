# frozen_string_literal: true

class RenameGTiposDeclaranteToCeTiposDeclarante < ActiveRecord::Migration[8.1]
  def up
    return unless table_exists?(:g_tipos_declarante)

    rename_table :g_tipos_declarante, :ce_tipos_declarante

    rename_index_if_exists :ce_tipos_declarante, "index_g_tipos_declarante_on_deleted_at", "index_ce_tipos_declarante_on_deleted_at"
    rename_index_if_exists :ce_tipos_declarante, "index_g_tipos_declarante_on_ordem", "index_ce_tipos_declarante_on_ordem"
    rename_index_if_exists :ce_tipos_declarante, "index_g_tipos_declarante_on_descricao", "index_ce_tipos_declarante_on_descricao"
  end

  def down
    return unless table_exists?(:ce_tipos_declarante)

    rename_index_if_exists :ce_tipos_declarante, "index_ce_tipos_declarante_on_descricao", "index_g_tipos_declarante_on_descricao"
    rename_index_if_exists :ce_tipos_declarante, "index_ce_tipos_declarante_on_ordem", "index_g_tipos_declarante_on_ordem"
    rename_index_if_exists :ce_tipos_declarante, "index_ce_tipos_declarante_on_deleted_at", "index_g_tipos_declarante_on_deleted_at"

    rename_table :ce_tipos_declarante, :g_tipos_declarante
  end

  private

  def rename_index_if_exists(table_name, old_name, new_name)
    rename_index table_name, old_name, new_name if index_name_exists?(table_name, old_name)
  end
end
