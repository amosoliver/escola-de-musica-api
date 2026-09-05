# frozen_string_literal: true

namespace :instrumentos do
  namespace :referenciais do
    def populate_referencial(table_name, records)
      model = Class.new(ApplicationRecord) { self.table_name = table_name }

      records.each do |attributes|
        record = model.find_or_initialize_by(codigo: attributes.fetch(:codigo))
        record.assign_attributes(attributes)
        record.deleted_at = nil
        record.save!
      end
    end

    desc "Popula as classificacoes de instrumentos"
    task classificacoes: :environment do
      populate_referencial("g_classificacoes_instrumentos", [
        { codigo: "RITMICO", descricao: "Ritmico", ativo: true },
        { codigo: "MELODICO", descricao: "Melodico", ativo: true },
        { codigo: "HARMONICO", descricao: "Harmonico", ativo: true }
      ])
    end

    desc "Popula os tipos de instrumentos"
    task tipos: :environment do
      classification_model = Class.new(ApplicationRecord) { self.table_name = "g_classificacoes_instrumentos" }
      type_model = Class.new(ApplicationRecord) { self.table_name = "g_tipos_instrumentos" }

      [
        [ "MELODICO", "CORDAS", "Cordas" ], [ "MELODICO", "MADEIRAS", "Madeiras" ],
        [ "MELODICO", "METAIS", "Metais" ], [ "RITMICO", "PERCUSSAO", "Percussao" ],
        [ "HARMONICO", "TECLAS", "Teclas" ], [ "MELODICO", "VOZ", "Voz" ],
        [ "HARMONICO", "ELETRONICOS", "Eletronicos" ], [ "MELODICO", "OUTROS", "Outros" ]
      ].each do |classification_code, code, description|
        classification = classification_model.find_by!(codigo: classification_code, deleted_at: nil)
        record = type_model.find_or_initialize_by(codigo: code)
        record.g_classificacao_instrumento_id = classification.id
        record.assign_attributes(descricao: description, ativo: true, deleted_at: nil)
        record.save!
      end
    end

    desc "Popula os instrumentos"
    task instrumentos: :environment do
      type_model = Class.new(ApplicationRecord) { self.table_name = "g_tipos_instrumentos" }
      instrument_model = Class.new(ApplicationRecord) { self.table_name = "g_instrumentos" }

      [
        [ "CORDAS", "VIOLINO", "Violino" ], [ "CORDAS", "VIOLA", "Viola" ], [ "CORDAS", "VIOLONCELO", "Violoncelo" ],
        [ "CORDAS", "VIOLAO", "Violao" ], [ "CORDAS", "GUITARRA", "Guitarra" ],
        [ "MADEIRAS", "FLAUTA", "Flauta" ], [ "MADEIRAS", "CLARINETE", "Clarinete" ], [ "MADEIRAS", "SAXOFONE", "Saxofone" ],
        [ "METAIS", "TROMPETE", "Trompete" ], [ "METAIS", "TROMBONE", "Trombone" ], [ "METAIS", "TUBA", "Tuba" ],
        [ "PERCUSSAO", "BATERIA", "Bateria" ], [ "PERCUSSAO", "CAJON", "Cajon" ], [ "PERCUSSAO", "PANDEIRO", "Pandeiro" ],
        [ "TECLAS", "PIANO", "Piano" ], [ "TECLAS", "TECLADO", "Teclado" ], [ "TECLAS", "ORGAO", "Orgao" ],
        [ "VOZ", "CANTO", "Canto" ]
      ].each do |type_code, code, description|
        type = type_model.find_by!(codigo: type_code, deleted_at: nil)
        record = instrument_model.find_or_initialize_by(codigo: code)
        record.g_tipo_instrumento_id = type.id
        record.assign_attributes(descricao: description, ativo: true, deleted_at: nil)
        record.save!
      end
    end

    desc "Popula todos os referenciais globais de instrumentos"
    task populate_all: :environment do
      %w[classificacoes tipos instrumentos].each do |task_name|
        task = Rake::Task["instrumentos:referenciais:#{task_name}"]
        task.reenable
        task.invoke
      end
    end
  end
end
