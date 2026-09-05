# frozen_string_literal: true

class PEstadoConservacaoPatrimonio < PatrimonioReferencial
  self.table_name = "p_estados_conservacoes_patrimonios"

  validates :ordem, presence: true, numericality: { only_integer: true }, uniqueness: { conditions: -> { where(deleted_at: nil) } }
end
