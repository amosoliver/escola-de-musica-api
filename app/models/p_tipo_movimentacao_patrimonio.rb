# frozen_string_literal: true

class PTipoMovimentacaoPatrimonio < PatrimonioReferencial
  self.table_name = "p_tipos_movimentacoes_patrimonios"

  validate :destinos_nao_podem_coexistir

  private

  def destinos_nao_podem_coexistir
    errors.add(:base, "nao pode permitir destinos interno e externo simultaneamente") if destino_interno && destino_externo
  end
end
