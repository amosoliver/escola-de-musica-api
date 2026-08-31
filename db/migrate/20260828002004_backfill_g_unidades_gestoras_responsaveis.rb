# frozen_string_literal: true

class BackfillGUnidadesGestorasResponsaveis < ActiveRecord::Migration[8.1]
  def up
    insert_responsaveis_principais_por_admin_escola
    sync_responsavel_nome_em_branco
  end

  def down; end

  private

  def insert_responsaveis_principais_por_admin_escola
    execute <<~SQL
      INSERT INTO g_unidades_gestoras_responsaveis (
        g_unidade_gestora_id,
        g_pessoa_id,
        u_perfil_id,
        principal,
        data_inicio,
        ativo,
        created_at,
        updated_at
      )
      SELECT up.g_unidade_gestora_id,
             u.g_pessoa_id,
             up.u_perfil_id,
             TRUE,
             CURRENT_DATE,
             TRUE,
             CURRENT_TIMESTAMP,
             CURRENT_TIMESTAMP
      FROM users_perfis up
      INNER JOIN users u
        ON u.id = up.user_id
       AND u.deleted_at IS NULL
       AND u.g_pessoa_id IS NOT NULL
      INNER JOIN u_perfis perfil
        ON perfil.id = up.u_perfil_id
       AND perfil.deleted_at IS NULL
       AND perfil.codigo = 'ADMIN_ESCOLA'
      INNER JOIN (
        SELECT up.g_unidade_gestora_id,
               MIN(up.id) AS user_perfil_id
        FROM users_perfis up
        INNER JOIN users u
          ON u.id = up.user_id
         AND u.deleted_at IS NULL
         AND u.g_pessoa_id IS NOT NULL
        INNER JOIN u_perfis perfil
          ON perfil.id = up.u_perfil_id
         AND perfil.deleted_at IS NULL
         AND perfil.codigo = 'ADMIN_ESCOLA'
        WHERE up.deleted_at IS NULL
          AND up.ativo = TRUE
          AND up.g_unidade_gestora_id IS NOT NULL
        GROUP BY up.g_unidade_gestora_id
        HAVING COUNT(DISTINCT up.user_id) = 1
      ) escolhido
        ON escolhido.user_perfil_id = up.id
      WHERE up.deleted_at IS NULL
        AND up.ativo = TRUE
        AND NOT EXISTS (
          SELECT 1
          FROM g_unidades_gestoras_responsaveis gur
          WHERE gur.g_unidade_gestora_id = up.g_unidade_gestora_id
            AND gur.principal = TRUE
            AND gur.ativo = TRUE
            AND gur.deleted_at IS NULL
        )
        AND NOT EXISTS (
          SELECT 1
          FROM g_unidades_gestoras_responsaveis gur
          WHERE gur.g_unidade_gestora_id = up.g_unidade_gestora_id
            AND gur.g_pessoa_id = u.g_pessoa_id
            AND gur.deleted_at IS NULL
        )
    SQL
  end

  def sync_responsavel_nome_em_branco
    execute <<~SQL
      UPDATE g_unidades_gestoras
      SET responsavel_nome = gp.nome,
          updated_at = CURRENT_TIMESTAMP
      FROM g_unidades_gestoras_responsaveis gur
      INNER JOIN g_pessoas gp
        ON gp.id = gur.g_pessoa_id
       AND gp.deleted_at IS NULL
      WHERE g_unidades_gestoras.id = gur.g_unidade_gestora_id
        AND gur.principal = TRUE
        AND gur.ativo = TRUE
        AND gur.deleted_at IS NULL
        AND COALESCE(TRIM(g_unidades_gestoras.responsavel_nome), '') = ''
    SQL
  end
end
