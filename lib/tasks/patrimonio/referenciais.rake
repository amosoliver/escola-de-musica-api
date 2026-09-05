# frozen_string_literal: true

namespace :patrimonio do
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

    desc "Popula as situacoes de patrimonio"
    task situacoes: :environment do
      populate_referencial("p_situacoes_patrimonios", [
        { codigo: "DISPONIVEL", descricao: "Disponivel", permite_emprestimo: true, permite_movimentacao: true, ativo: true },
        { codigo: "EM_USO", descricao: "Em uso", permite_emprestimo: false, permite_movimentacao: true, ativo: true },
        { codigo: "EMPRESTADO", descricao: "Emprestado", permite_emprestimo: false, permite_movimentacao: true, ativo: true },
        { codigo: "EM_MANUTENCAO", descricao: "Em manutencao", permite_emprestimo: false, permite_movimentacao: true, ativo: true },
        { codigo: "INDISPONIVEL", descricao: "Indisponivel", permite_emprestimo: false, permite_movimentacao: true, ativo: true },
        { codigo: "EXTRAVIADO", descricao: "Extraviado", permite_emprestimo: false, permite_movimentacao: false, ativo: true },
        { codigo: "BAIXADO", descricao: "Baixado", permite_emprestimo: false, permite_movimentacao: false, ativo: true }
      ])
    end

    desc "Popula os estados de conservacao de patrimonio"
    task estados_conservacao: :environment do
      populate_referencial("p_estados_conservacoes_patrimonios", [
        { codigo: "NOVO", descricao: "Novo", ordem: 1, ativo: true }, { codigo: "OTIMO", descricao: "Otimo", ordem: 2, ativo: true },
        { codigo: "BOM", descricao: "Bom", ordem: 3, ativo: true }, { codigo: "REGULAR", descricao: "Regular", ordem: 4, ativo: true },
        { codigo: "RUIM", descricao: "Ruim", ordem: 5, ativo: true }, { codigo: "INSERVIVEL", descricao: "Inservivel", ordem: 6, ativo: true }
      ])
    end

    desc "Popula os tipos de aquisicao de patrimonio"
    task tipos_aquisicao: :environment do
      populate_referencial("p_tipos_aquisicoes_patrimonios", [
        { codigo: "COMPRA", descricao: "Compra", ativo: true }, { codigo: "DOACAO", descricao: "Doacao", ativo: true },
        { codigo: "CESSAO", descricao: "Cessao", ativo: true }, { codigo: "COMODATO", descricao: "Comodato", ativo: true },
        { codigo: "TRANSFERENCIA", descricao: "Transferencia", ativo: true }, { codigo: "OUTRO", descricao: "Outro", ativo: true }
      ])
    end

    desc "Popula os tipos de arquivo de patrimonio"
    task tipos_arquivos: :environment do
      populate_referencial("p_tipos_arquivos_patrimonios", [
        { codigo: "FOTO", descricao: "Foto", ativo: true }, { codigo: "NOTA_FISCAL", descricao: "Nota fiscal", ativo: true },
        { codigo: "MANUAL", descricao: "Manual", ativo: true }, { codigo: "GARANTIA", descricao: "Garantia", ativo: true },
        { codigo: "TERMO", descricao: "Termo", ativo: true }, { codigo: "LAUDO", descricao: "Laudo", ativo: true },
        { codigo: "OUTRO", descricao: "Outro", ativo: true }
      ])
    end

    desc "Popula os tipos de movimentacao de patrimonio"
    task tipos_movimentacoes: :environment do
      populate_referencial("p_tipos_movimentacoes_patrimonios", [
        { codigo: "TRANSFERENCIA_INTERNA", descricao: "Transferencia interna", destino_interno: true, destino_externo: false, movimentacao_definitiva: false, ativo: true },
        { codigo: "DOACAO", descricao: "Doacao", destino_interno: false, destino_externo: true, movimentacao_definitiva: true, ativo: true },
        { codigo: "VENDA", descricao: "Venda", destino_interno: false, destino_externo: true, movimentacao_definitiva: true, ativo: true },
        { codigo: "CESSAO", descricao: "Cessao", destino_interno: false, destino_externo: true, movimentacao_definitiva: false, ativo: true },
        { codigo: "MANUTENCAO_EXTERNA", descricao: "Manutencao externa", destino_interno: false, destino_externo: true, movimentacao_definitiva: false, ativo: true },
        { codigo: "RETORNO_MANUTENCAO", descricao: "Retorno de manutencao", destino_interno: true, destino_externo: false, movimentacao_definitiva: false, ativo: true },
        { codigo: "TRANSFERENCIA_DEFINITIVA", descricao: "Transferencia definitiva", destino_interno: false, destino_externo: true, movimentacao_definitiva: true, ativo: true },
        { codigo: "DESCARTE", descricao: "Descarte", destino_interno: false, destino_externo: true, movimentacao_definitiva: true, ativo: true }
      ])
    end

    desc "Popula os status de emprestimo de patrimonio"
    task status_emprestimos: :environment do
      populate_referencial("p_status_emprestimos_patrimonios", [
        { codigo: "ABERTO", descricao: "Aberto", finalizador: false, ativo: true },
        { codigo: "PARCIALMENTE_DEVOLVIDO", descricao: "Parcialmente devolvido", finalizador: false, ativo: true },
        { codigo: "DEVOLVIDO", descricao: "Devolvido", finalizador: true, ativo: true },
        { codigo: "ATRASADO", descricao: "Atrasado", finalizador: false, ativo: true },
        { codigo: "CANCELADO", descricao: "Cancelado", finalizador: true, ativo: true }
      ])
    end

    desc "Popula os tipos de manutencao de patrimonio"
    task tipos_manutencoes: :environment do
      populate_referencial("p_tipos_manutencoes_patrimonios", [
        { codigo: "PREVENTIVA", descricao: "Preventiva", ativo: true }, { codigo: "CORRETIVA", descricao: "Corretiva", ativo: true },
        { codigo: "LIMPEZA", descricao: "Limpeza", ativo: true }, { codigo: "AFINACAO", descricao: "Afinacao", ativo: true },
        { codigo: "REVISAO", descricao: "Revisao", ativo: true }, { codigo: "REPARO", descricao: "Reparo", ativo: true },
        { codigo: "OUTRA", descricao: "Outra", ativo: true }
      ])
    end

    desc "Popula os status de manutencao de patrimonio"
    task status_manutencoes: :environment do
      populate_referencial("p_status_manutencoes_patrimonios", [
        { codigo: "SOLICITADA", descricao: "Solicitada", finalizador: false, ativo: true },
        { codigo: "APROVADA", descricao: "Aprovada", finalizador: false, ativo: true },
        { codigo: "AGENDADA", descricao: "Agendada", finalizador: false, ativo: true },
        { codigo: "EM_ANDAMENTO", descricao: "Em andamento", finalizador: false, ativo: true },
        { codigo: "CONCLUIDA", descricao: "Concluida", finalizador: true, ativo: true },
        { codigo: "CANCELADA", descricao: "Cancelada", finalizador: true, ativo: true }
      ])
    end

    desc "Popula os tipos de baixa de patrimonio"
    task tipos_baixas: :environment do
      populate_referencial("p_tipos_baixas_patrimonios", [
        { codigo: "VENDA", descricao: "Venda", ativo: true }, { codigo: "DOACAO", descricao: "Doacao", ativo: true },
        { codigo: "DESCARTE", descricao: "Descarte", ativo: true }, { codigo: "EXTRAVIO", descricao: "Extravio", ativo: true },
        { codigo: "SINISTRO", descricao: "Sinistro", ativo: true }, { codigo: "INSERVIBILIDADE", descricao: "Inservibilidade", ativo: true },
        { codigo: "TRANSFERENCIA_DEFINITIVA", descricao: "Transferencia definitiva", ativo: true }
      ])
    end

    desc "Popula todos os referenciais do modulo de patrimonio"
    task populate_all: :environment do
      %w[
        situacoes
        estados_conservacao
        tipos_aquisicao
        tipos_arquivos
        tipos_movimentacoes
        status_emprestimos
        tipos_manutencoes
        status_manutencoes
        tipos_baixas
      ].each do |task_name|
        task = Rake::Task["patrimonio:referenciais:#{task_name}"]
        task.reenable
        task.invoke
      end
    end
  end
end
