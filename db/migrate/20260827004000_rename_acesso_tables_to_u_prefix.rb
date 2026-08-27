# frozen_string_literal: true

class RenameAcessoTablesToUPrefix < ActiveRecord::Migration[8.1]
  def up
    rename_table :g_perfis, :u_perfis if table_exists?(:g_perfis)
    rename_table :g_permissoes, :u_permissoes if table_exists?(:g_permissoes)
    rename_table :g_templates, :u_templates if table_exists?(:g_templates)
    rename_table :g_sidebars, :u_sidebars if table_exists?(:g_sidebars)
    rename_table :g_rotas, :u_rotas if table_exists?(:g_rotas)
    rename_table :g_sidebar_itens, :u_sidebar_itens if table_exists?(:g_sidebar_itens)
    rename_table :g_perfis_permissoes, :u_perfis_permissoes if table_exists?(:g_perfis_permissoes)
    rename_table :g_perfis_templates, :u_perfis_templates if table_exists?(:g_perfis_templates)
    rename_table :g_rotas_permissoes, :u_rotas_permissoes if table_exists?(:g_rotas_permissoes)

    rename_column :users_perfis, :g_perfil_id, :u_perfil_id if column_exists?(:users_perfis, :g_perfil_id)
    rename_column :u_perfis_permissoes, :g_perfil_id, :u_perfil_id if column_exists?(:u_perfis_permissoes, :g_perfil_id)
    rename_column :u_perfis_permissoes, :g_permissao_id, :u_permissao_id if column_exists?(:u_perfis_permissoes, :g_permissao_id)
    rename_column :u_perfis_templates, :g_perfil_id, :u_perfil_id if column_exists?(:u_perfis_templates, :g_perfil_id)
    rename_column :u_perfis_templates, :g_template_id, :u_template_id if column_exists?(:u_perfis_templates, :g_template_id)
    rename_column :u_sidebars, :g_template_id, :u_template_id if column_exists?(:u_sidebars, :g_template_id)
    rename_column :u_sidebar_itens, :g_sidebar_id, :u_sidebar_id if column_exists?(:u_sidebar_itens, :g_sidebar_id)
    rename_column :u_sidebar_itens, :g_sidebar_item_pai_id, :u_sidebar_item_pai_id if column_exists?(:u_sidebar_itens, :g_sidebar_item_pai_id)
    rename_column :u_sidebar_itens, :g_rota_id, :u_rota_id if column_exists?(:u_sidebar_itens, :g_rota_id)
    rename_column :u_rotas_permissoes, :g_rota_id, :u_rota_id if column_exists?(:u_rotas_permissoes, :g_rota_id)
    rename_column :u_rotas_permissoes, :g_permissao_id, :u_permissao_id if column_exists?(:u_rotas_permissoes, :g_permissao_id)

    rename_index_if_exists :u_perfis, "index_g_perfis_on_deleted_at", "index_u_perfis_on_deleted_at"
    rename_index_if_exists :u_permissoes, "index_g_permissoes_on_deleted_at", "index_u_permissoes_on_deleted_at"
    rename_index_if_exists :u_templates, "index_g_templates_on_deleted_at", "index_u_templates_on_deleted_at"
    rename_index_if_exists :u_rotas, "index_g_rotas_on_deleted_at", "index_u_rotas_on_deleted_at"

    rename_index_if_exists :u_sidebars, "index_g_sidebars_on_deleted_at", "index_u_sidebars_on_deleted_at"
    rename_index_if_exists :u_sidebars, "index_g_sidebars_on_g_template_id", "index_u_sidebars_on_u_template_id"

    rename_index_if_exists :u_sidebar_itens, "index_g_sidebar_itens_on_deleted_at", "index_u_sidebar_itens_on_deleted_at"
    rename_index_if_exists :u_sidebar_itens, "index_g_sidebar_itens_on_g_sidebar_id", "index_u_sidebar_itens_on_u_sidebar_id"
    rename_index_if_exists :u_sidebar_itens, "index_g_sidebar_itens_on_g_sidebar_item_pai_id", "index_u_sidebar_itens_on_u_sidebar_item_pai_id"
    rename_index_if_exists :u_sidebar_itens, "index_g_sidebar_itens_on_g_rota_id", "index_u_sidebar_itens_on_u_rota_id"

    rename_index_if_exists :u_perfis_permissoes, "index_g_perfis_permissoes_on_deleted_at", "index_u_perfis_permissoes_on_deleted_at"
    rename_index_if_exists :u_perfis_permissoes, "index_g_perfis_permissoes_on_g_perfil_id", "index_u_perfis_permissoes_on_u_perfil_id"
    rename_index_if_exists :u_perfis_permissoes, "index_g_perfis_permissoes_on_g_permissao_id", "index_u_perfis_permissoes_on_u_permissao_id"

    rename_index_if_exists :u_perfis_templates, "index_g_perfis_templates_on_deleted_at", "index_u_perfis_templates_on_deleted_at"
    rename_index_if_exists :u_perfis_templates, "index_g_perfis_templates_on_g_perfil_id", "index_u_perfis_templates_on_u_perfil_id"
    rename_index_if_exists :u_perfis_templates, "index_g_perfis_templates_on_g_template_id", "index_u_perfis_templates_on_u_template_id"

    rename_index_if_exists :u_rotas_permissoes, "index_g_rotas_permissoes_on_deleted_at", "index_u_rotas_permissoes_on_deleted_at"
    rename_index_if_exists :u_rotas_permissoes, "index_g_rotas_permissoes_on_g_rota_id", "index_u_rotas_permissoes_on_u_rota_id"
    rename_index_if_exists :u_rotas_permissoes, "index_g_rotas_permissoes_on_g_permissao_id", "index_u_rotas_permissoes_on_u_permissao_id"

    rename_index_if_exists :users_perfis, "index_users_perfis_on_g_perfil_id", "index_users_perfis_on_u_perfil_id"

    refresh_foreign_keys_up
  end

  def down
    refresh_foreign_keys_down

    rename_index_if_exists :users_perfis, "index_users_perfis_on_u_perfil_id", "index_users_perfis_on_g_perfil_id"

    rename_index_if_exists :u_rotas_permissoes, "index_u_rotas_permissoes_on_u_permissao_id", "index_g_rotas_permissoes_on_g_permissao_id"
    rename_index_if_exists :u_rotas_permissoes, "index_u_rotas_permissoes_on_u_rota_id", "index_g_rotas_permissoes_on_g_rota_id"
    rename_index_if_exists :u_rotas_permissoes, "index_u_rotas_permissoes_on_deleted_at", "index_g_rotas_permissoes_on_deleted_at"

    rename_index_if_exists :u_perfis_templates, "index_u_perfis_templates_on_u_template_id", "index_g_perfis_templates_on_g_template_id"
    rename_index_if_exists :u_perfis_templates, "index_u_perfis_templates_on_u_perfil_id", "index_g_perfis_templates_on_g_perfil_id"
    rename_index_if_exists :u_perfis_templates, "index_u_perfis_templates_on_deleted_at", "index_g_perfis_templates_on_deleted_at"

    rename_index_if_exists :u_perfis_permissoes, "index_u_perfis_permissoes_on_u_permissao_id", "index_g_perfis_permissoes_on_g_permissao_id"
    rename_index_if_exists :u_perfis_permissoes, "index_u_perfis_permissoes_on_u_perfil_id", "index_g_perfis_permissoes_on_g_perfil_id"
    rename_index_if_exists :u_perfis_permissoes, "index_u_perfis_permissoes_on_deleted_at", "index_g_perfis_permissoes_on_deleted_at"

    rename_index_if_exists :u_sidebar_itens, "index_u_sidebar_itens_on_u_rota_id", "index_g_sidebar_itens_on_g_rota_id"
    rename_index_if_exists :u_sidebar_itens, "index_u_sidebar_itens_on_u_sidebar_item_pai_id", "index_g_sidebar_itens_on_g_sidebar_item_pai_id"
    rename_index_if_exists :u_sidebar_itens, "index_u_sidebar_itens_on_u_sidebar_id", "index_g_sidebar_itens_on_g_sidebar_id"
    rename_index_if_exists :u_sidebar_itens, "index_u_sidebar_itens_on_deleted_at", "index_g_sidebar_itens_on_deleted_at"

    rename_index_if_exists :u_sidebars, "index_u_sidebars_on_u_template_id", "index_g_sidebars_on_g_template_id"
    rename_index_if_exists :u_sidebars, "index_u_sidebars_on_deleted_at", "index_g_sidebars_on_deleted_at"

    rename_index_if_exists :u_rotas, "index_u_rotas_on_deleted_at", "index_g_rotas_on_deleted_at"
    rename_index_if_exists :u_templates, "index_u_templates_on_deleted_at", "index_g_templates_on_deleted_at"
    rename_index_if_exists :u_permissoes, "index_u_permissoes_on_deleted_at", "index_g_permissoes_on_deleted_at"
    rename_index_if_exists :u_perfis, "index_u_perfis_on_deleted_at", "index_g_perfis_on_deleted_at"

    rename_column :u_rotas_permissoes, :u_permissao_id, :g_permissao_id if column_exists?(:u_rotas_permissoes, :u_permissao_id)
    rename_column :u_rotas_permissoes, :u_rota_id, :g_rota_id if column_exists?(:u_rotas_permissoes, :u_rota_id)
    rename_column :u_sidebar_itens, :u_rota_id, :g_rota_id if column_exists?(:u_sidebar_itens, :u_rota_id)
    rename_column :u_sidebar_itens, :u_sidebar_item_pai_id, :g_sidebar_item_pai_id if column_exists?(:u_sidebar_itens, :u_sidebar_item_pai_id)
    rename_column :u_sidebar_itens, :u_sidebar_id, :g_sidebar_id if column_exists?(:u_sidebar_itens, :u_sidebar_id)
    rename_column :u_sidebars, :u_template_id, :g_template_id if column_exists?(:u_sidebars, :u_template_id)
    rename_column :u_perfis_templates, :u_template_id, :g_template_id if column_exists?(:u_perfis_templates, :u_template_id)
    rename_column :u_perfis_templates, :u_perfil_id, :g_perfil_id if column_exists?(:u_perfis_templates, :u_perfil_id)
    rename_column :u_perfis_permissoes, :u_permissao_id, :g_permissao_id if column_exists?(:u_perfis_permissoes, :u_permissao_id)
    rename_column :u_perfis_permissoes, :u_perfil_id, :g_perfil_id if column_exists?(:u_perfis_permissoes, :u_perfil_id)
    rename_column :users_perfis, :u_perfil_id, :g_perfil_id if column_exists?(:users_perfis, :u_perfil_id)

    rename_table :u_rotas_permissoes, :g_rotas_permissoes if table_exists?(:u_rotas_permissoes)
    rename_table :u_perfis_templates, :g_perfis_templates if table_exists?(:u_perfis_templates)
    rename_table :u_perfis_permissoes, :g_perfis_permissoes if table_exists?(:u_perfis_permissoes)
    rename_table :u_sidebar_itens, :g_sidebar_itens if table_exists?(:u_sidebar_itens)
    rename_table :u_rotas, :g_rotas if table_exists?(:u_rotas)
    rename_table :u_sidebars, :g_sidebars if table_exists?(:u_sidebars)
    rename_table :u_templates, :g_templates if table_exists?(:u_templates)
    rename_table :u_permissoes, :g_permissoes if table_exists?(:u_permissoes)
    rename_table :u_perfis, :g_perfis if table_exists?(:u_perfis)
  end

  private

  def rename_index_if_exists(table_name, old_name, new_name)
    rename_index table_name, old_name, new_name if index_name_exists?(table_name, old_name)
  end

  def refresh_foreign_keys_up
    remove_foreign_key :users_perfis, column: :u_perfil_id if foreign_key_exists?(:users_perfis, column: :u_perfil_id)
    add_foreign_key :users_perfis, :u_perfis, column: :u_perfil_id unless foreign_key_exists?(:users_perfis, :u_perfis, column: :u_perfil_id)

    remove_foreign_key :u_perfis_permissoes, column: :u_perfil_id if foreign_key_exists?(:u_perfis_permissoes, column: :u_perfil_id)
    remove_foreign_key :u_perfis_permissoes, column: :u_permissao_id if foreign_key_exists?(:u_perfis_permissoes, column: :u_permissao_id)
    add_foreign_key :u_perfis_permissoes, :u_perfis, column: :u_perfil_id unless foreign_key_exists?(:u_perfis_permissoes, :u_perfis, column: :u_perfil_id)
    add_foreign_key :u_perfis_permissoes, :u_permissoes, column: :u_permissao_id unless foreign_key_exists?(:u_perfis_permissoes, :u_permissoes, column: :u_permissao_id)

    remove_foreign_key :u_perfis_templates, column: :u_perfil_id if foreign_key_exists?(:u_perfis_templates, column: :u_perfil_id)
    remove_foreign_key :u_perfis_templates, column: :u_template_id if foreign_key_exists?(:u_perfis_templates, column: :u_template_id)
    add_foreign_key :u_perfis_templates, :u_perfis, column: :u_perfil_id unless foreign_key_exists?(:u_perfis_templates, :u_perfis, column: :u_perfil_id)
    add_foreign_key :u_perfis_templates, :u_templates, column: :u_template_id unless foreign_key_exists?(:u_perfis_templates, :u_templates, column: :u_template_id)

    remove_foreign_key :u_sidebars, column: :u_template_id if foreign_key_exists?(:u_sidebars, column: :u_template_id)
    add_foreign_key :u_sidebars, :u_templates, column: :u_template_id unless foreign_key_exists?(:u_sidebars, :u_templates, column: :u_template_id)

    remove_foreign_key :u_sidebar_itens, column: :u_sidebar_id if foreign_key_exists?(:u_sidebar_itens, column: :u_sidebar_id)
    remove_foreign_key :u_sidebar_itens, column: :u_sidebar_item_pai_id if foreign_key_exists?(:u_sidebar_itens, column: :u_sidebar_item_pai_id)
    remove_foreign_key :u_sidebar_itens, column: :u_rota_id if foreign_key_exists?(:u_sidebar_itens, column: :u_rota_id)
    add_foreign_key :u_sidebar_itens, :u_sidebars, column: :u_sidebar_id unless foreign_key_exists?(:u_sidebar_itens, :u_sidebars, column: :u_sidebar_id)
    add_foreign_key :u_sidebar_itens, :u_sidebar_itens, column: :u_sidebar_item_pai_id unless foreign_key_exists?(:u_sidebar_itens, :u_sidebar_itens, column: :u_sidebar_item_pai_id)
    add_foreign_key :u_sidebar_itens, :u_rotas, column: :u_rota_id unless foreign_key_exists?(:u_sidebar_itens, :u_rotas, column: :u_rota_id)

    remove_foreign_key :u_rotas_permissoes, column: :u_rota_id if foreign_key_exists?(:u_rotas_permissoes, column: :u_rota_id)
    remove_foreign_key :u_rotas_permissoes, column: :u_permissao_id if foreign_key_exists?(:u_rotas_permissoes, column: :u_permissao_id)
    add_foreign_key :u_rotas_permissoes, :u_rotas, column: :u_rota_id unless foreign_key_exists?(:u_rotas_permissoes, :u_rotas, column: :u_rota_id)
    add_foreign_key :u_rotas_permissoes, :u_permissoes, column: :u_permissao_id unless foreign_key_exists?(:u_rotas_permissoes, :u_permissoes, column: :u_permissao_id)
  end

  def refresh_foreign_keys_down
    remove_foreign_key :u_rotas_permissoes, column: :u_permissao_id if foreign_key_exists?(:u_rotas_permissoes, :u_permissoes, column: :u_permissao_id)
    remove_foreign_key :u_rotas_permissoes, column: :u_rota_id if foreign_key_exists?(:u_rotas_permissoes, :u_rotas, column: :u_rota_id)
    add_foreign_key :u_rotas_permissoes, :g_rotas, column: :u_rota_id if table_exists?(:g_rotas) && column_exists?(:u_rotas_permissoes, :u_rota_id)
    add_foreign_key :u_rotas_permissoes, :g_permissoes, column: :u_permissao_id if table_exists?(:g_permissoes) && column_exists?(:u_rotas_permissoes, :u_permissao_id)

    remove_foreign_key :u_sidebar_itens, column: :u_rota_id if foreign_key_exists?(:u_sidebar_itens, :u_rotas, column: :u_rota_id)
    remove_foreign_key :u_sidebar_itens, column: :u_sidebar_item_pai_id if foreign_key_exists?(:u_sidebar_itens, :u_sidebar_itens, column: :u_sidebar_item_pai_id)
    remove_foreign_key :u_sidebar_itens, column: :u_sidebar_id if foreign_key_exists?(:u_sidebar_itens, :u_sidebars, column: :u_sidebar_id)
    add_foreign_key :u_sidebar_itens, :g_rotas, column: :u_rota_id if table_exists?(:g_rotas) && column_exists?(:u_sidebar_itens, :u_rota_id)
    add_foreign_key :u_sidebar_itens, :g_sidebar_itens, column: :u_sidebar_item_pai_id if table_exists?(:g_sidebar_itens) && column_exists?(:u_sidebar_itens, :u_sidebar_item_pai_id)
    add_foreign_key :u_sidebar_itens, :g_sidebars, column: :u_sidebar_id if table_exists?(:g_sidebars) && column_exists?(:u_sidebar_itens, :u_sidebar_id)

    remove_foreign_key :u_sidebars, column: :u_template_id if foreign_key_exists?(:u_sidebars, :u_templates, column: :u_template_id)
    add_foreign_key :u_sidebars, :g_templates, column: :u_template_id if table_exists?(:g_templates) && column_exists?(:u_sidebars, :u_template_id)

    remove_foreign_key :u_perfis_templates, column: :u_template_id if foreign_key_exists?(:u_perfis_templates, :u_templates, column: :u_template_id)
    remove_foreign_key :u_perfis_templates, column: :u_perfil_id if foreign_key_exists?(:u_perfis_templates, :u_perfis, column: :u_perfil_id)
    add_foreign_key :u_perfis_templates, :g_templates, column: :u_template_id if table_exists?(:g_templates) && column_exists?(:u_perfis_templates, :u_template_id)
    add_foreign_key :u_perfis_templates, :g_perfis, column: :u_perfil_id if table_exists?(:g_perfis) && column_exists?(:u_perfis_templates, :u_perfil_id)

    remove_foreign_key :u_perfis_permissoes, column: :u_permissao_id if foreign_key_exists?(:u_perfis_permissoes, :u_permissoes, column: :u_permissao_id)
    remove_foreign_key :u_perfis_permissoes, column: :u_perfil_id if foreign_key_exists?(:u_perfis_permissoes, :u_perfis, column: :u_perfil_id)
    add_foreign_key :u_perfis_permissoes, :g_permissoes, column: :u_permissao_id if table_exists?(:g_permissoes) && column_exists?(:u_perfis_permissoes, :u_permissao_id)
    add_foreign_key :u_perfis_permissoes, :g_perfis, column: :u_perfil_id if table_exists?(:g_perfis) && column_exists?(:u_perfis_permissoes, :u_perfil_id)

    remove_foreign_key :users_perfis, column: :u_perfil_id if foreign_key_exists?(:users_perfis, :u_perfis, column: :u_perfil_id)
    add_foreign_key :users_perfis, :g_perfis, column: :u_perfil_id if table_exists?(:g_perfis) && column_exists?(:users_perfis, :u_perfil_id)
  end
end
