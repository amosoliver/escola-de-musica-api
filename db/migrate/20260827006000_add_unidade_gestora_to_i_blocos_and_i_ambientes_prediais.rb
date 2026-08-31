# frozen_string_literal: true

# Denormaliza g_unidade_gestora_id em i_blocos e i_ambientes_prediais (hoje so
# i_predios tem) pra permitir filtrar por tenant sem precisar subir a cadeia
# i_ambiente_predial -> i_bloco -> i_predio -> g_unidade_gestora a cada query.
# O valor e' sempre derivado do pai (ver IBloco/IAmbientePredial#before_validation),
# o backfill abaixo so cobre registros ja existentes antes desta migration.
class AddUnidadeGestoraToIBlocosAndIAmbientesPrediais < ActiveRecord::Migration[8.1]
  def up
    add_reference :i_blocos, :g_unidade_gestora, foreign_key: true, if_not_exists: true
    add_reference :i_ambientes_prediais, :g_unidade_gestora, foreign_key: true, if_not_exists: true

    execute <<~SQL
      UPDATE i_blocos
      SET g_unidade_gestora_id = i_predios.g_unidade_gestora_id
      FROM i_predios
      WHERE i_blocos.i_predio_id = i_predios.id
        AND i_blocos.g_unidade_gestora_id IS NULL
    SQL

    execute <<~SQL
      UPDATE i_ambientes_prediais
      SET g_unidade_gestora_id = i_blocos.g_unidade_gestora_id
      FROM i_blocos
      WHERE i_ambientes_prediais.i_bloco_id = i_blocos.id
        AND i_ambientes_prediais.g_unidade_gestora_id IS NULL
    SQL
  end

  def down
    remove_reference :i_ambientes_prediais, :g_unidade_gestora, foreign_key: true, if_exists: true
    remove_reference :i_blocos, :g_unidade_gestora, foreign_key: true, if_exists: true
  end
end
