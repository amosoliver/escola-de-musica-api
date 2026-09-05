# frozen_string_literal: true

namespace :patrimonio do
  namespace :classificacao do
    def populate_referencial(table_name, records)
      model = Class.new(ApplicationRecord) { self.table_name = table_name }

      records.each do |attributes|
        record = model.find_or_initialize_by(codigo: attributes.fetch(:codigo))
        record.assign_attributes(attributes)
        record.deleted_at = nil
        record.save!
      end
    end

    desc "Popula as categorias patrimoniais"
    task categorias: :environment do
      populate_referencial("g_categorias_patrimonios", [
        { codigo: "INSTRUMENTO_MUSICAL", descricao: "Instrumento musical", ativo: true }
      ])
    end

    desc "Popula os tipos patrimoniais"
    task tipos: :environment do
      categoria_model = Class.new(ApplicationRecord) { self.table_name = "g_categorias_patrimonios" }
      tipo_model = Class.new(ApplicationRecord) { self.table_name = "g_tipos_patrimonios" }

      [
        [ "INSTRUMENTO_MUSICAL", "INSTRUMENTO", "Instrumento", true ]
      ].each do |categoria_codigo, codigo, descricao, representa_instrumento|
        categoria = categoria_model.find_by!(codigo: categoria_codigo, deleted_at: nil)
        record = tipo_model.find_or_initialize_by(codigo: codigo)
        record.g_categoria_patrimonio_id = categoria.id
        record.assign_attributes(descricao: descricao, representa_instrumento: representa_instrumento, ativo: true, deleted_at: nil)
        record.save!
      end
    end

    desc "Popula todos os referenciais de classificacao patrimonial"
    task populate_all: :environment do
      %w[categorias tipos].each do |task_name|
        task = Rake::Task["patrimonio:classificacao:#{task_name}"]
        task.reenable
        task.invoke
      end
    end
  end
end
