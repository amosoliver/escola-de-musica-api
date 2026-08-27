# frozen_string_literal: true

namespace :g_paises do
  desc "Popula g_paises com todos os países da API oficial de localidades do IBGE"
  task populate: :environment do
    summary = Importacao::Localidades.populate_paises
    puts "g_paises: #{GPais.count} registros. inseridos=#{summary[:inserted]} atualizados=#{summary[:updated]} ignorados=#{summary[:skipped]}"
  end
end

namespace :g_estados do
  desc "Popula g_estados com os estados do Brasil"
  task populate: :environment do
    Importacao::Localidades.populate_paises
    summary = Importacao::Localidades.populate_estados
    puts "g_estados: #{GEstado.count} registros. inseridos=#{summary[:inserted]} atualizados=#{summary[:updated]} ignorados=#{summary[:skipped]}"
  end
end

namespace :g_cidades do
  desc "Popula g_cidades a partir dos municípios do Brasil"
  task populate: :environment do
    Importacao::Localidades.populate_paises
    Importacao::Localidades.populate_estados
    summary = Importacao::Localidades.populate_cidades
    puts "g_cidades: #{GCidade.count} registros. inseridos=#{summary[:inserted]} atualizados=#{summary[:updated]} ignorados=#{summary[:skipped]}"
  end
end

namespace :g_bairros do
  desc "Popula g_bairros a partir do OpenStreetMap (Overpass API), 1 consulta por UF"
  task populate: :environment do
    summary = Importacao::Localidades.populate_bairros
    puts "g_bairros: #{GBairro.count} registros. inseridos=#{summary[:inserted]} atualizados=#{summary[:updated]} ignorados=#{summary[:skipped]}"
  end
end

namespace :localidades do
  desc "Popula países, estados, cidades e bairros em uma única execução"
  task populate_all: :environment do
    Importacao::Localidades.populate_all
    puts "Localidades importadas com sucesso."
  end
end
