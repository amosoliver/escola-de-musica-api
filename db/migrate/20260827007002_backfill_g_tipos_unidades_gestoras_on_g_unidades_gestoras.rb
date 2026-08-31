# frozen_string_literal: true

class BackfillGTiposUnidadesGestorasOnGUnidadesGestoras < ActiveRecord::Migration[8.1]
  class MigrationGTipoUnidadeGestora < ApplicationRecord
    self.table_name = "g_tipos_unidades_gestoras"
  end

  class MigrationGUnidadeGestora < ApplicationRecord
    self.table_name = "g_unidades_gestoras"
  end

  TIPO_ADMINISTRACAO = "ADMINISTRACAO".freeze
  TIPO_ESCOLA = "ESCOLA".freeze

  def up
    return unless column_exists?(:g_unidades_gestoras, :tipo_unidade)

    MigrationGUnidadeGestora.reset_column_information
    MigrationGTipoUnidadeGestora.reset_column_information

    ids_by_codigo = MigrationGTipoUnidadeGestora.pluck(:codigo, :id).to_h

    MigrationGUnidadeGestora.find_each do |unidade|
      next if unidade[:tipo_unidade].blank?

      tipo_id = ids_by_codigo[normalize_tipo(unidade[:tipo_unidade])]
      raise_unmapped_tipo!(unidade) if tipo_id.blank?

      unidade.update_columns(g_tipo_unidade_gestora_id: tipo_id)
    end

    remove_column :g_unidades_gestoras, :tipo_unidade, :string, if_exists: true
  end

  def down
    return if column_exists?(:g_unidades_gestoras, :tipo_unidade)

    add_column :g_unidades_gestoras, :tipo_unidade, :string, if_not_exists: true

    MigrationGUnidadeGestora.reset_column_information
    MigrationGTipoUnidadeGestora.reset_column_information

    MigrationGUnidadeGestora.find_each do |unidade|
      tipo = MigrationGTipoUnidadeGestora.find_by(id: unidade.g_tipo_unidade_gestora_id)
      unidade.update_columns(tipo_unidade: tipo&.codigo)
    end
  end

  private

  def normalize_tipo(value)
    normalized = value.to_s.strip.upcase
    return TIPO_ADMINISTRACAO if [ TIPO_ADMINISTRACAO, "ADMINISTRAÇÃO" ].include?(normalized)
    return TIPO_ESCOLA if normalized == TIPO_ESCOLA

    nil
  end

  def raise_unmapped_tipo!(unidade)
    raise ActiveRecord::IrreversibleMigration,
          "Nao foi possivel migrar o tipo_unidade '#{unidade[:tipo_unidade]}' da g_unidade_gestora #{unidade.id}"
  end
end
