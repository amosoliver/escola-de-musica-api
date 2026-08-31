# frozen_string_literal: true

class NormalizeLocalityReferences < ActiveRecord::Migration[8.1]
  class MigrationGPessoa < ApplicationRecord
    self.table_name = "g_pessoas"
  end

  class MigrationGBairro < ApplicationRecord
    self.table_name = "g_bairros"
  end

  class MigrationGCidade < ApplicationRecord
    self.table_name = "g_cidades"
  end

  class MigrationIPredio < ApplicationRecord
    self.table_name = "i_predios"
  end

  def up
    add_reference :g_pessoas, :g_bairro, foreign_key: true, if_not_exists: true
    backfill_g_pessoas_bairros!

    remove_column :g_pessoas, :bairro, :string, if_exists: true
    remove_column :g_pessoas, :cidade, :string, if_exists: true
    remove_column :g_pessoas, :uf, :string, if_exists: true

    remove_reference :g_cidades, :g_pais, foreign_key: true, if_exists: true
    remove_column :g_cidades, :uf, :string, if_exists: true

    remove_reference :i_predios, :g_pais, foreign_key: true, if_exists: true
  end

  def down
    add_reference :g_cidades, :g_pais, foreign_key: true, if_not_exists: true
    add_column :g_cidades, :uf, :string, if_not_exists: true

    MigrationGCidade.reset_column_information
    execute <<~SQL.squish
      UPDATE g_cidades
      SET g_pais_id = g_estados.g_pais_id,
          uf = g_estados.uf
      FROM g_estados
      WHERE g_cidades.g_estado_id = g_estados.id
    SQL

    add_reference :i_predios, :g_pais, foreign_key: true, if_not_exists: true
    MigrationIPredio.reset_column_information
    execute <<~SQL.squish
      UPDATE i_predios
      SET g_pais_id = g_cidades.g_pais_id
      FROM g_cidades
      WHERE i_predios.g_cidade_id = g_cidades.id
    SQL

    add_column :g_pessoas, :bairro, :string, if_not_exists: true
    add_column :g_pessoas, :cidade, :string, if_not_exists: true
    add_column :g_pessoas, :uf, :string, if_not_exists: true

    MigrationGPessoa.reset_column_information
    execute <<~SQL.squish
      UPDATE g_pessoas
      SET bairro = g_bairros.descricao,
          cidade = g_cidades.descricao,
          uf = g_estados.uf
      FROM g_bairros
      INNER JOIN g_cidades ON g_bairros.g_cidade_id = g_cidades.id
      INNER JOIN g_estados ON g_cidades.g_estado_id = g_estados.id
      WHERE g_pessoas.g_bairro_id = g_bairros.id
    SQL

    remove_reference :g_pessoas, :g_bairro, foreign_key: true, if_exists: true
  end

  private

  def backfill_g_pessoas_bairros!
    MigrationGPessoa.reset_column_information
    MigrationGBairro.reset_column_information
    MigrationGCidade.reset_column_information

    bairros_por_chave = MigrationGBairro.joins("INNER JOIN g_cidades ON g_bairros.g_cidade_id = g_cidades.id")
                                      .joins("INNER JOIN g_estados ON g_cidades.g_estado_id = g_estados.id")
                                      .pluck("g_bairros.id", "g_bairros.descricao", "g_cidades.descricao", "g_estados.uf")
                                      .each_with_object({}) do |(bairro_id, bairro, cidade, uf), memo|
      memo[match_key(bairro, cidade, uf)] = bairro_id
    end

    MigrationGPessoa.find_each do |pessoa|
      key = match_key(pessoa[:bairro], pessoa[:cidade], pessoa[:uf])
      next if key.blank?

      bairro_id = bairros_por_chave[key]
      next if bairro_id.blank?

      pessoa.update_columns(g_bairro_id: bairro_id)
    end
  end

  def match_key(bairro, cidade, uf)
    values = [ bairro, cidade, uf ].map { |value| normalize(value) }
    return if values.any?(&:blank?)

    values.join("|")
  end

  def normalize(value)
    I18n.transliterate(value.to_s).downcase.strip.squeeze(" ")
  end
end
