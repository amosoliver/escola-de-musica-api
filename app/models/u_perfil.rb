# frozen_string_literal: true

class UPerfil < ApplicationRecord
  acts_as_paranoid

  ADMIN_PLATAFORMA = "ADMIN_PLATAFORMA"
  ADMIN_ESCOLA = "ADMIN_ESCOLA"
  SECRETARIA = "SECRETARIA"
  FINANCEIRO = "FINANCEIRO"
  PROFESSOR = "PROFESSOR"
  AUXILIAR = "AUXILIAR"
  ALUNO = "ALUNO"
  RESPONSAVEL_LEGAL = "RESPONSAVEL_LEGAL"

  has_many :u_perfis_permissoes, dependent: :destroy
  has_many :u_permissoes, through: :u_perfis_permissoes

  has_many :u_perfis_templates, dependent: :destroy
  has_many :u_templates, through: :u_perfis_templates

  has_many :users_perfis, dependent: :restrict_with_exception
  has_many :r_funcoes_perfis, dependent: :restrict_with_exception
  has_many :r_funcoes, through: :r_funcoes_perfis
  has_many :g_unidades_gestoras_responsaveis, dependent: :restrict_with_exception

  def self.fetch_id_by_codigo!(codigo)
    find_by!(codigo:).id
  end
end
