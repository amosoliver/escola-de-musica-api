# frozen_string_literal: true

class RSetorFuncao < ApplicationRecord
  acts_as_paranoid

  belongs_to :r_setor
  belongs_to :r_funcao

  has_many :r_funcionarios_setores_funcoes, dependent: :destroy
  has_many :r_funcionarios, through: :r_funcionarios_setores_funcoes

  validates :r_funcao_id, uniqueness: {
    scope: :r_setor_id,
    conditions: -> { where(deleted_at: nil) }
  }
  validate :apenas_uma_funcao_principal_ativa_por_setor

  private

  def apenas_uma_funcao_principal_ativa_por_setor
    return unless principal? && ativo?

    scope = self.class.where(r_setor_id:, principal: true, ativo: true, deleted_at: nil)
    scope = scope.where.not(id:) if persisted?
    return unless scope.exists?

    errors.add(:principal, "permite apenas uma funcao principal ativa por setor")
  end
end
