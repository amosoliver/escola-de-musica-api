# frozen_string_literal: true

class PPatrimonio < ApplicationRecord
  acts_as_paranoid

  belongs_to :g_unidade_gestora
  belongs_to :g_instrumento, optional: true
  belongs_to :g_tipo_patrimonio, optional: true
  belongs_to :i_ambiente_predial, optional: true
  belongs_to :p_estado_conservacao_patrimonio
  belongs_to :p_situacao_patrimonio
  belongs_to :p_tipo_aquisicao_patrimonio, optional: true

  delegate :g_categoria_patrimonio, to: :g_tipo_patrimonio, allow_nil: true

  has_many :p_patrimonios_arquivos, class_name: "PPatrimonioArquivo", dependent: :destroy
  has_many :p_patrimonios_responsaveis, class_name: "PPatrimonioResponsavel", dependent: :destroy
  has_many :p_movimentacoes_patrimonios, class_name: "PMovimentacaoPatrimonio", dependent: :restrict_with_exception
  has_many :p_manutencoes_patrimonios, class_name: "PManutencaoPatrimonio", dependent: :restrict_with_exception
  has_many :p_emprestimos_itens, class_name: "PEmprestimoItem", dependent: :restrict_with_exception
  has_many :p_inventarios_itens, class_name: "PInventarioItem", dependent: :restrict_with_exception
  has_one :p_baixa_patrimonio, dependent: :restrict_with_exception

  validates :descricao, presence: true
  validates :codigo_patrimonial, presence: true, uniqueness: {
    scope: :g_unidade_gestora_id,
    case_sensitive: false,
    conditions: -> { where(deleted_at: nil) }
  }

  def responsavel_principal
    p_patrimonios_responsaveis.find_by(principal: true, ativo: true)
  end
end
