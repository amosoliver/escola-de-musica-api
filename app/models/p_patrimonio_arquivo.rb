# frozen_string_literal: true

class PPatrimonioArquivo < ApplicationRecord
  self.table_name = "p_patrimonios_arquivos"

  acts_as_paranoid

  belongs_to :p_patrimonio
  belongs_to :p_tipo_arquivo_patrimonio

  validates :arquivo, presence: true
end
