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

    def populate_all
      [
        populate_andares,
        populate_sexos,
        populate_situacoes_predios,
        populate_tipos_ambientes_prediais,
        populate_perfis,
        populate_tipos_declarante
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
