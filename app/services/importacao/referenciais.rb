# frozen_string_literal: true

module Importacao
  module Referenciais
    extend self

    TASK_USER = "task:referenciais".freeze

    ANDARES = [
      { descricao: "Terreo", ordem: 0 },
      *1.upto(20).map { |numero| { descricao: "#{numero} Andar", ordem: numero } }
    ].freeze

    SEXOS = [
      "Masculino",
      "Feminino",
      "Outro",
      "Nao informado"
    ].freeze

    SITUACOES_PREDIO = [
      "Ativo",
      "Inativo",
      "Em manutencao",
      "Em reforma",
      "Interditado"
    ].freeze

    TIPOS_AMBIENTES_PREDIAIS = [
      "Recepcao",
      "Secretaria",
      "Sala de aula",
      "Sala de pratica individual",
      "Sala de ensaio",
      "Estudio",
      "Auditorio",
      "Biblioteca",
      "Laboratorio",
      "Banheiro",
      "Copa",
      "Almoxarifado",
      "Patio",
      "Administrativo"
    ].freeze

    TIPOS_DECLARANTE = [
      { descricao: "O proprio estudante", ordem: 1 },
      { descricao: "Pai ou mãe", ordem: 2 },
      { descricao: "Outros", ordem: 3 }
    ].freeze

    TIPOS_UNIDADES_GESTORAS = [
      { codigo: GTipoUnidadeGestora::ADMINISTRACAO, descricao: "Administracao" },
      { codigo: GTipoUnidadeGestora::ESCOLA, descricao: "Escola" }
    ].freeze

    ALERGIAS = [
      "Amendoim",
      "Leite",
      "Gluten",
      "Dipirona",
      "Penicilina",
      "Picada de inseto"
    ].freeze

    NECESSIDADES_ESPECIFICAS = [
      "TEA",
      "TDAH",
      "Deficiencia visual",
      "Deficiencia auditiva",
      "Deficiencia fisica",
      "Deficiencia intelectual",
      "Dislexia",
      "Altas habilidades",
      "Mobilidade reduzida"
    ].freeze

    PARENTESCOS = [
      { descricao: "Mae", permite_outro: false },
      { descricao: "Pai", permite_outro: false },
      { descricao: "Avo(a)", permite_outro: false },
      { descricao: "Tio", permite_outro: false },
      { descricao: "Irmao", permite_outro: false },
      { descricao: "Responsavel legal", permite_outro: false },
      { descricao: "Outro", permite_outro: true }
    ].freeze

    SETORES = [
      { codigo: "MANTENEDORA_CONSELHO_ESCOLAR", descricao: "Mantenedora / Conselho Escolar", ordem: 1 },
      { codigo: "DIRETORIA_GERAL", descricao: "Diretoria Geral", ordem: 2, codigo_pai: "MANTENEDORA_CONSELHO_ESCOLAR" },
      { codigo: "SECRETARIA_ESCOLAR", descricao: "Secretaria Escolar", ordem: 3, codigo_pai: "DIRETORIA_GERAL" },
      { codigo: "ASSESSORIA_JURIDICA_RH", descricao: "Assessoria Juridica / RH", ordem: 4, codigo_pai: "DIRETORIA_GERAL" },
      { codigo: "COORDENACAO_PEDAGOGICA", descricao: "Coordenacao Pedagogica", ordem: 5, codigo_pai: "DIRETORIA_GERAL" },
      { codigo: "CORPO_DOCENTE", descricao: "Corpo Docente", ordem: 6, codigo_pai: "COORDENACAO_PEDAGOGICA" },
      { codigo: "BIBLIOTECA", descricao: "Biblioteca", ordem: 7, codigo_pai: "COORDENACAO_PEDAGOGICA" },
      { codigo: "LABORATORIOS", descricao: "Laboratorios", ordem: 8, codigo_pai: "COORDENACAO_PEDAGOGICA" },
      { codigo: "COORDENACAO_EDUCACIONAL", descricao: "Coordenacao Educacional", ordem: 9, codigo_pai: "DIRETORIA_GERAL" },
      { codigo: "ATENDIMENTO_AO_ALUNO", descricao: "Atendimento ao Aluno", ordem: 10, codigo_pai: "COORDENACAO_EDUCACIONAL" },
      { codigo: "RELACAO_COM_FAMILIAS", descricao: "Relacao com Familias", ordem: 11, codigo_pai: "COORDENACAO_EDUCACIONAL" },
      { codigo: "GESTAO_ADMINISTRATIVA_FINANCEIRA", descricao: "Gestao Administrativa e Financeira", ordem: 12,
        codigo_pai: "DIRETORIA_GERAL" },
      { codigo: "TESOURARIA", descricao: "Tesouraria", ordem: 13, codigo_pai: "GESTAO_ADMINISTRATIVA_FINANCEIRA" },
      { codigo: "SERVICOS_GERAIS_MANUTENCAO", descricao: "Servicos Gerais / Manutencao", ordem: 14,
        codigo_pai: "GESTAO_ADMINISTRATIVA_FINANCEIRA" },
      { codigo: "SEGURANCA_PORTARIA", descricao: "Seguranca / Portaria", ordem: 15,
        codigo_pai: "GESTAO_ADMINISTRATIVA_FINANCEIRA" },
      { codigo: "NUTRICAO_CANTINA", descricao: "Nutricao / Cantina", ordem: 16,
        codigo_pai: "GESTAO_ADMINISTRATIVA_FINANCEIRA" }
    ].freeze

    PERFIS = [
      { descricao: "Administrador da Plataforma", codigo: "ADMIN_PLATAFORMA", ativo: true },
      { descricao: "Administrador da Escola", codigo: "ADMIN_ESCOLA", ativo: true },
      { descricao: "Secretaria", codigo: "SECRETARIA", ativo: true },
      { descricao: "Financeiro", codigo: "FINANCEIRO", ativo: true },
      { descricao: "Professor", codigo: "PROFESSOR", ativo: true },
      { descricao: "Auxiliar", codigo: "AUXILIAR", ativo: true },
      { descricao: "Aluno", codigo: "ALUNO", ativo: true },
      { descricao: "Responsavel Legal", codigo: "RESPONSAVEL_LEGAL", ativo: true }
    ].freeze

    def populate_andares
      upsert_by_attribute(
        GAndar,
        ANDARES,
        key: :ordem,
        label: "g_andares"
      )
    end

    def populate_sexos
      upsert_by_attribute(
        GSexo,
        SEXOS.map { |descricao| { descricao: } },
        key: :descricao,
        label: "g_sexos"
      )
    end

    def populate_situacoes_predios
      upsert_by_attribute(
        GSituacaoPredio,
        SITUACOES_PREDIO.map { |descricao| { descricao: } },
        key: :descricao,
        label: "g_situacoes_predios"
      )
    end

    def populate_tipos_ambientes_prediais
      upsert_by_attribute(
        GTipoAmbientePredial,
        TIPOS_AMBIENTES_PREDIAIS.map { |descricao| { descricao: } },
        key: :descricao,
        label: "g_tipos_ambientes_prediais"
      )
    end

    def populate_perfis
      upsert_by_attribute(
        UPerfil,
        PERFIS,
        key: :codigo,
        label: "u_perfis"
      )
    end

    def populate_tipos_declarante
      now = Time.current
      existing_by_ordem = CeTipoDeclarante.with_deleted.index_by(&:ordem)
      existing_by_descricao = CeTipoDeclarante.with_deleted.index_by(&:descricao)
      inserts = []
      updates = 0
      skipped = 0

      TIPOS_DECLARANTE.each do |row|
        existing = existing_by_ordem[row[:ordem]] || existing_by_descricao[row[:descricao]]

        if existing
          changed = assign_if_changed(existing, row.merge(updated_by: TASK_USER))
          restore_if_deleted(existing)
          changed ||= existing.changed?

          if changed
            existing.save!
            updates += 1
          else
            skipped += 1
          end
        else
          inserts << row.merge(
            created_by: TASK_USER,
            updated_by: TASK_USER,
            created_at: now,
            updated_at: now
          )
        end
      end

      CeTipoDeclarante.insert_all(inserts) if inserts.any?

      {
        label: "ce_tipos_declarante",
        fetched: TIPOS_DECLARANTE.size,
        inserted: inserts.size,
        updated: updates,
        skipped:
      }
    end

    def populate_tipos_unidades_gestoras
      upsert_by_attribute(
        GTipoUnidadeGestora,
        TIPOS_UNIDADES_GESTORAS,
        key: :codigo,
        label: "g_tipos_unidades_gestoras"
      )
    end

    def populate_alergias
      upsert_by_attribute(
        GAlergia,
        ALERGIAS.map { |descricao| { descricao:, ativo: true } },
        key: :descricao,
        label: "g_alergias"
      )
    end

    def populate_necessidades_especificas
      upsert_by_attribute(
        GNecessidadeEspecifica,
        NECESSIDADES_ESPECIFICAS.map { |descricao| { descricao:, ativo: true } },
        key: :descricao,
        label: "g_necessidades_especificas"
      )
    end

    def populate_parentescos
      upsert_by_attribute(
        GParentesco,
        PARENTESCOS,
        key: :descricao,
        label: "g_parentescos"
      )
    end

    def populate_setores
      escolas = GUnidadeGestora.joins(:g_tipo_unidade_gestora)
                               .where(g_tipos_unidades_gestoras: { codigo: GTipoUnidadeGestora::ESCOLA })

      resultados = escolas.find_each.map { |unidade| populate_setores_for_unidade(unidade:) }

      {
        label: "r_setores",
        fetched: resultados.sum { |resultado| resultado[:fetched] },
        inserted: resultados.sum { |resultado| resultado[:inserted] },
        updated: resultados.sum { |resultado| resultado[:updated] },
        skipped: resultados.sum { |resultado| resultado[:skipped] }
      }
    end

    def populate_setores_for_unidade(unidade:)
      now = Time.current
      inserted = 0
      updated = 0
      skipped = 0
      setores_existentes = unidade.r_setores.with_deleted.index_by(&:codigo)

      SETORES.each do |row|
        setor = setores_existentes[row[:codigo]] || unidade.r_setores.with_deleted.build(codigo: row[:codigo])
        parent = row[:codigo_pai].present? ? setores_existentes[row[:codigo_pai]] : nil

        changed = assign_if_changed(
          setor,
          descricao: row[:descricao],
          ordem: row[:ordem],
          ativo: true,
          g_unidade_gestora_id: unidade.id,
          r_setor_pai_id: parent&.id,
          updated_by: TASK_USER
        )
        restore_if_deleted(setor)
        changed ||= setor.changed?

        if setor.new_record?
          setor.created_by = TASK_USER
          setor.created_at = now
        end

        setor.updated_at = now if changed || setor.new_record?

        if setor.new_record? || changed
          setor.save!
          inserted += 1 if setor.previous_changes.key?("id")
          updated += 1 unless setor.previous_changes.key?("id")
        else
          skipped += 1
        end

        setores_existentes[row[:codigo]] = setor
      end

      {
        label: "r_setores",
        fetched: SETORES.size,
        inserted:,
        updated:,
        skipped:
      }
    end

    def populate_all
      [
        populate_andares,
        populate_sexos,
        populate_situacoes_predios,
        populate_tipos_ambientes_prediais,
        populate_tipos_declarante,
        populate_tipos_unidades_gestoras,
        populate_alergias,
        populate_necessidades_especificas,
        populate_parentescos,
        populate_setores,
        populate_perfis
      ]
    end

    private

    def upsert_by_attribute(model_class, rows, key:, label:)
      now = Time.current
      existing_by_key = model_class.with_deleted.index_by { |record| record.public_send(key) }
      inserts = []
      updates = 0
      skipped = 0

      rows.each do |row|
        lookup_value = row.fetch(key)
        existing = existing_by_key[lookup_value]

        if existing
          changed = assign_if_changed(existing, row.merge(updated_by: TASK_USER))
          restore_if_deleted(existing)
          changed ||= existing.changed?

          if changed
            existing.save!
            updates += 1
          else
            skipped += 1
          end
        else
          inserts << row.merge(
            created_by: TASK_USER,
            updated_by: TASK_USER,
            created_at: now,
            updated_at: now
          )
        end
      end

      model_class.insert_all(inserts) if inserts.any?

      {
        label:,
        fetched: rows.size,
        inserted: inserts.size,
        updated: updates,
        skipped:
      }
    end

    def assign_if_changed(record, attributes)
      changed = false

      attributes.each do |key, value|
        next if record.public_send(key) == value

        record.public_send("#{key}=", value)
        changed = true
      end

      changed
    end

    def restore_if_deleted(record)
      return unless record.respond_to?(:deleted_at) && record.deleted_at.present?

      record.deleted_at = nil
    end
  end
end
