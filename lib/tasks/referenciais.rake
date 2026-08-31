# frozen_string_literal: true

namespace :g_andares do
  desc "Popula g_andares com Terreo e andares de 1 a 20"
  task populate: :environment do
    summary = Importacao::Referenciais.populate_andares
    puts "g_andares: #{GAndar.count} registros. inseridos=#{summary[:inserted]} atualizados=#{summary[:updated]} ignorados=#{summary[:skipped]}"
  end
end

namespace :g_sexos do
  desc "Popula g_sexos com os sexos padrao do sistema"
  task populate: :environment do
    summary = Importacao::Referenciais.populate_sexos
    puts "g_sexos: #{GSexo.count} registros. inseridos=#{summary[:inserted]} atualizados=#{summary[:updated]} ignorados=#{summary[:skipped]}"
  end
end

namespace :g_situacoes_predios do
  desc "Popula g_situacoes_predios com os status padrao de predio"
  task populate: :environment do
    summary = Importacao::Referenciais.populate_situacoes_predios
    puts "g_situacoes_predios: #{GSituacaoPredio.count} registros. inseridos=#{summary[:inserted]} atualizados=#{summary[:updated]} ignorados=#{summary[:skipped]}"
  end
end

namespace :g_tipos_ambientes_prediais do
  desc "Popula g_tipos_ambientes_prediais com os ambientes base da escola"
  task populate: :environment do
    summary = Importacao::Referenciais.populate_tipos_ambientes_prediais
    puts "g_tipos_ambientes_prediais: #{GTipoAmbientePredial.count} registros. inseridos=#{summary[:inserted]} atualizados=#{summary[:updated]} ignorados=#{summary[:skipped]}"
  end
end

namespace :ce_tipos_declarante do
  desc "Popula ce_tipos_declarante com os tipos base de declarante"
  task populate: :environment do
    summary = Importacao::Referenciais.populate_tipos_declarante
    puts "ce_tipos_declarante: #{CeTipoDeclarante.count} registros. inseridos=#{summary[:inserted]} atualizados=#{summary[:updated]} ignorados=#{summary[:skipped]}"
  end
end

namespace :g_tipos_unidades_gestoras do
  desc "Popula g_tipos_unidades_gestoras com os tipos base de unidade gestora"
  task populate: :environment do
    summary = Importacao::Referenciais.populate_tipos_unidades_gestoras
    puts "g_tipos_unidades_gestoras: #{GTipoUnidadeGestora.count} registros. inseridos=#{summary[:inserted]} atualizados=#{summary[:updated]} ignorados=#{summary[:skipped]}"
  end
end

namespace :g_alergias do
  desc "Popula g_alergias com as alergias base do sistema"
  task populate: :environment do
    summary = Importacao::Referenciais.populate_alergias
    puts "g_alergias: #{GAlergia.count} registros. inseridos=#{summary[:inserted]} atualizados=#{summary[:updated]} ignorados=#{summary[:skipped]}"
  end
end

namespace :g_necessidades_especificas do
  desc "Popula g_necessidades_especificas com as necessidades especificas base do sistema"
  task populate: :environment do
    summary = Importacao::Referenciais.populate_necessidades_especificas
    puts "g_necessidades_especificas: #{GNecessidadeEspecifica.count} registros. inseridos=#{summary[:inserted]} atualizados=#{summary[:updated]} ignorados=#{summary[:skipped]}"
  end
end

namespace :g_parentescos do
  desc "Popula g_parentescos com os parentescos base do sistema"
  task populate: :environment do
    summary = Importacao::Referenciais.populate_parentescos
    puts "g_parentescos: #{GParentesco.count} registros. inseridos=#{summary[:inserted]} atualizados=#{summary[:updated]} ignorados=#{summary[:skipped]}"
  end
end

namespace :u_perfis do
  desc "Popula u_perfis com os perfis base da plataforma e da escola"
  task populate: :environment do
    summary = Importacao::Referenciais.populate_perfis
    puts "u_perfis: #{UPerfil.count} registros. inseridos=#{summary[:inserted]} atualizados=#{summary[:updated]} ignorados=#{summary[:skipped]}"
  end
end

namespace :r_setores do
  desc "Popula r_setores com o organograma base das unidades gestoras do tipo escola"
  task populate: :environment do
    summary = Importacao::Referenciais.populate_setores
    puts "r_setores: #{RSetor.count} registros. inseridos=#{summary[:inserted]} atualizados=#{summary[:updated]} ignorados=#{summary[:skipped]}"
  end
end

namespace :referenciais do
  desc "Popula os referenciais base de andares, sexos, situacoes, ambientes, tipos de unidade, saude e perfis"
  task populate_all: :environment do
    Importacao::Referenciais.populate_all
    puts "Referenciais importados com sucesso."
  end
end
