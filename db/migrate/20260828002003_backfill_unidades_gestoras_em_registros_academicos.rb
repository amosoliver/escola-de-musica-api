# frozen_string_literal: true

class BackfillUnidadesGestorasEmRegistrosAcademicos < ActiveRecord::Migration[8.1]
  def up
    backfill_estudantes_por_acesso
    backfill_responsaveis_por_estudantes
    backfill_responsaveis_por_acesso
  end

  def down; end

  private

  def backfill_estudantes_por_acesso
    execute <<~SQL
      UPDATE e_estudantes
      SET g_unidade_gestora_id = origem.g_unidade_gestora_id,
          updated_at = CURRENT_TIMESTAMP
      FROM (
        SELECT ee.id AS e_estudante_id,
               MIN(up.g_unidade_gestora_id) AS g_unidade_gestora_id
        FROM e_estudantes ee
        INNER JOIN g_pessoas gp
          ON gp.id = ee.g_pessoa_id
         AND gp.deleted_at IS NULL
        INNER JOIN users u
          ON u.g_pessoa_id = gp.id
         AND u.deleted_at IS NULL
        INNER JOIN users_perfis up
          ON up.user_id = u.id
         AND up.deleted_at IS NULL
         AND up.ativo = TRUE
         AND up.g_unidade_gestora_id IS NOT NULL
        WHERE ee.deleted_at IS NULL
          AND ee.g_unidade_gestora_id IS NULL
        GROUP BY ee.id
        HAVING COUNT(DISTINCT up.g_unidade_gestora_id) = 1
      ) origem
      WHERE e_estudantes.id = origem.e_estudante_id
        AND e_estudantes.g_unidade_gestora_id IS NULL
    SQL
  end

  def backfill_responsaveis_por_estudantes
    execute <<~SQL
      UPDATE e_responsaveis
      SET g_unidade_gestora_id = origem.g_unidade_gestora_id,
          updated_at = CURRENT_TIMESTAMP
      FROM (
        SELECT er.id AS e_responsavel_id,
               MIN(ee.g_unidade_gestora_id) AS g_unidade_gestora_id
        FROM e_responsaveis er
        INNER JOIN e_estudantes_responsaveis eer
          ON eer.e_responsavel_id = er.id
         AND eer.deleted_at IS NULL
        INNER JOIN e_estudantes ee
          ON ee.id = eer.e_estudante_id
         AND ee.deleted_at IS NULL
         AND ee.g_unidade_gestora_id IS NOT NULL
        WHERE er.deleted_at IS NULL
          AND er.g_unidade_gestora_id IS NULL
        GROUP BY er.id
        HAVING COUNT(DISTINCT ee.g_unidade_gestora_id) = 1
      ) origem
      WHERE e_responsaveis.id = origem.e_responsavel_id
        AND e_responsaveis.g_unidade_gestora_id IS NULL
    SQL
  end

  def backfill_responsaveis_por_acesso
    execute <<~SQL
      UPDATE e_responsaveis
      SET g_unidade_gestora_id = origem.g_unidade_gestora_id,
          updated_at = CURRENT_TIMESTAMP
      FROM (
        SELECT er.id AS e_responsavel_id,
               MIN(up.g_unidade_gestora_id) AS g_unidade_gestora_id
        FROM e_responsaveis er
        INNER JOIN g_pessoas gp
          ON gp.id = er.g_pessoa_id
         AND gp.deleted_at IS NULL
        INNER JOIN users u
          ON u.g_pessoa_id = gp.id
         AND u.deleted_at IS NULL
        INNER JOIN users_perfis up
          ON up.user_id = u.id
         AND up.deleted_at IS NULL
         AND up.ativo = TRUE
         AND up.g_unidade_gestora_id IS NOT NULL
        WHERE er.deleted_at IS NULL
          AND er.g_unidade_gestora_id IS NULL
        GROUP BY er.id
        HAVING COUNT(DISTINCT up.g_unidade_gestora_id) = 1
      ) origem
      WHERE e_responsaveis.id = origem.e_responsavel_id
        AND e_responsaveis.g_unidade_gestora_id IS NULL
    SQL
  end
end
