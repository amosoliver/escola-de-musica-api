# frozen_string_literal: true

class RenameEstruturaTablesToInfraestrutura < ActiveRecord::Migration[8.1]
  def up
    rename_table :e_predios, :i_predios if table_exists?(:e_predios)
    rename_table :e_blocos, :i_blocos if table_exists?(:e_blocos)
    rename_table :e_ambientes_prediais, :i_ambientes_prediais if table_exists?(:e_ambientes_prediais)

    rename_column :i_blocos, :e_predio_id, :i_predio_id if column_exists?(:i_blocos, :e_predio_id)
    rename_column :i_ambientes_prediais, :e_bloco_id, :i_bloco_id if column_exists?(:i_ambientes_prediais, :e_bloco_id)

    rename_index :i_predios, "index_e_predios_on_deleted_at", "index_i_predios_on_deleted_at" if index_name_exists?(:i_predios, "index_e_predios_on_deleted_at")
    rename_index :i_predios, "index_e_predios_on_g_bairro_id", "index_i_predios_on_g_bairro_id" if index_name_exists?(:i_predios, "index_e_predios_on_g_bairro_id")
    rename_index :i_predios, "index_e_predios_on_g_cidade_id", "index_i_predios_on_g_cidade_id" if index_name_exists?(:i_predios, "index_e_predios_on_g_cidade_id")
    rename_index :i_predios, "index_e_predios_on_g_pais_id", "index_i_predios_on_g_pais_id" if index_name_exists?(:i_predios, "index_e_predios_on_g_pais_id")
    rename_index :i_predios, "index_e_predios_on_g_situacao_predio_id", "index_i_predios_on_g_situacao_predio_id" if index_name_exists?(:i_predios, "index_e_predios_on_g_situacao_predio_id")
    rename_index :i_predios, "index_e_predios_on_g_tipo_predio_id", "index_i_predios_on_g_tipo_predio_id" if index_name_exists?(:i_predios, "index_e_predios_on_g_tipo_predio_id")
    rename_index :i_predios, "index_e_predios_on_g_unidade_gestora_id", "index_i_predios_on_g_unidade_gestora_id" if index_name_exists?(:i_predios, "index_e_predios_on_g_unidade_gestora_id")

    rename_index :i_blocos, "index_e_blocos_on_deleted_at", "index_i_blocos_on_deleted_at" if index_name_exists?(:i_blocos, "index_e_blocos_on_deleted_at")
    rename_index :i_blocos, "index_e_blocos_on_e_predio_id", "index_i_blocos_on_i_predio_id" if index_name_exists?(:i_blocos, "index_e_blocos_on_e_predio_id")
    rename_index :i_blocos, "index_e_blocos_on_g_andar_id", "index_i_blocos_on_g_andar_id" if index_name_exists?(:i_blocos, "index_e_blocos_on_g_andar_id")

    rename_index :i_ambientes_prediais, "index_e_ambientes_prediais_on_deleted_at", "index_i_ambientes_prediais_on_deleted_at" if index_name_exists?(:i_ambientes_prediais, "index_e_ambientes_prediais_on_deleted_at")
    rename_index :i_ambientes_prediais, "index_e_ambientes_prediais_on_e_bloco_id", "index_i_ambientes_prediais_on_i_bloco_id" if index_name_exists?(:i_ambientes_prediais, "index_e_ambientes_prediais_on_e_bloco_id")
    rename_index :i_ambientes_prediais, "index_e_ambientes_prediais_on_g_tipo_ambiente_predial_id", "index_i_ambientes_prediais_on_g_tipo_ambiente_predial_id" if index_name_exists?(:i_ambientes_prediais, "index_e_ambientes_prediais_on_g_tipo_ambiente_predial_id")

    remove_foreign_key :i_blocos, column: :i_predio_id if foreign_key_exists?(:i_blocos, column: :i_predio_id)
    add_foreign_key :i_blocos, :i_predios, column: :i_predio_id unless foreign_key_exists?(:i_blocos, :i_predios, column: :i_predio_id)

    remove_foreign_key :i_ambientes_prediais, column: :i_bloco_id if foreign_key_exists?(:i_ambientes_prediais, column: :i_bloco_id)
    add_foreign_key :i_ambientes_prediais, :i_blocos, column: :i_bloco_id unless foreign_key_exists?(:i_ambientes_prediais, :i_blocos, column: :i_bloco_id)
  end

  def down
    remove_foreign_key :i_ambientes_prediais, column: :i_bloco_id if foreign_key_exists?(:i_ambientes_prediais, :i_blocos, column: :i_bloco_id)
    add_foreign_key :i_ambientes_prediais, :e_blocos, column: :i_bloco_id if table_exists?(:e_blocos) && column_exists?(:i_ambientes_prediais, :i_bloco_id)

    remove_foreign_key :i_blocos, column: :i_predio_id if foreign_key_exists?(:i_blocos, :i_predios, column: :i_predio_id)
    add_foreign_key :i_blocos, :e_predios, column: :i_predio_id if table_exists?(:e_predios) && column_exists?(:i_blocos, :i_predio_id)

    rename_index :i_ambientes_prediais, "index_i_ambientes_prediais_on_g_tipo_ambiente_predial_id", "index_e_ambientes_prediais_on_g_tipo_ambiente_predial_id" if index_name_exists?(:i_ambientes_prediais, "index_i_ambientes_prediais_on_g_tipo_ambiente_predial_id")
    rename_index :i_ambientes_prediais, "index_i_ambientes_prediais_on_i_bloco_id", "index_e_ambientes_prediais_on_e_bloco_id" if index_name_exists?(:i_ambientes_prediais, "index_i_ambientes_prediais_on_i_bloco_id")
    rename_index :i_ambientes_prediais, "index_i_ambientes_prediais_on_deleted_at", "index_e_ambientes_prediais_on_deleted_at" if index_name_exists?(:i_ambientes_prediais, "index_i_ambientes_prediais_on_deleted_at")

    rename_index :i_blocos, "index_i_blocos_on_g_andar_id", "index_e_blocos_on_g_andar_id" if index_name_exists?(:i_blocos, "index_i_blocos_on_g_andar_id")
    rename_index :i_blocos, "index_i_blocos_on_i_predio_id", "index_e_blocos_on_e_predio_id" if index_name_exists?(:i_blocos, "index_i_blocos_on_i_predio_id")
    rename_index :i_blocos, "index_i_blocos_on_deleted_at", "index_e_blocos_on_deleted_at" if index_name_exists?(:i_blocos, "index_i_blocos_on_deleted_at")

    rename_index :i_predios, "index_i_predios_on_g_unidade_gestora_id", "index_e_predios_on_g_unidade_gestora_id" if index_name_exists?(:i_predios, "index_i_predios_on_g_unidade_gestora_id")
    rename_index :i_predios, "index_i_predios_on_g_tipo_predio_id", "index_e_predios_on_g_tipo_predio_id" if index_name_exists?(:i_predios, "index_i_predios_on_g_tipo_predio_id")
    rename_index :i_predios, "index_i_predios_on_g_situacao_predio_id", "index_e_predios_on_g_situacao_predio_id" if index_name_exists?(:i_predios, "index_i_predios_on_g_situacao_predio_id")
    rename_index :i_predios, "index_i_predios_on_g_pais_id", "index_e_predios_on_g_pais_id" if index_name_exists?(:i_predios, "index_i_predios_on_g_pais_id")
    rename_index :i_predios, "index_i_predios_on_g_cidade_id", "index_e_predios_on_g_cidade_id" if index_name_exists?(:i_predios, "index_i_predios_on_g_cidade_id")
    rename_index :i_predios, "index_i_predios_on_g_bairro_id", "index_e_predios_on_g_bairro_id" if index_name_exists?(:i_predios, "index_i_predios_on_g_bairro_id")
    rename_index :i_predios, "index_i_predios_on_deleted_at", "index_e_predios_on_deleted_at" if index_name_exists?(:i_predios, "index_i_predios_on_deleted_at")

    rename_column :i_ambientes_prediais, :i_bloco_id, :e_bloco_id if column_exists?(:i_ambientes_prediais, :i_bloco_id)
    rename_column :i_blocos, :i_predio_id, :e_predio_id if column_exists?(:i_blocos, :i_predio_id)

    rename_table :i_ambientes_prediais, :e_ambientes_prediais if table_exists?(:i_ambientes_prediais)
    rename_table :i_blocos, :e_blocos if table_exists?(:i_blocos)
    rename_table :i_predios, :e_predios if table_exists?(:i_predios)
  end
end
