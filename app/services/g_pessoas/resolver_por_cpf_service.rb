# frozen_string_literal: true

module GPessoas
  class ResolverPorCpfService
    def self.call(g_pessoa_id:, g_pessoa_attributes:, atualizar_g_pessoa: false)
      new(g_pessoa_id:, g_pessoa_attributes:, atualizar_g_pessoa:).call
    end

    def initialize(g_pessoa_id:, g_pessoa_attributes:, atualizar_g_pessoa:)
      @g_pessoa_id = g_pessoa_id
      @g_pessoa_attributes = (g_pessoa_attributes || {}).deep_symbolize_keys
      @atualizar_g_pessoa = ActiveModel::Type::Boolean.new.cast(atualizar_g_pessoa)
    end

    def call
      return resolve_por_id if g_pessoa_id.present?
      return failure("Informe a pessoa ou os dados da pessoa") if g_pessoa_attributes.blank?

      g_pessoa = cpf.present? ? GPessoa.find_by(cpf:) : nil
      return atualizar_ou_reutilizar(g_pessoa) if g_pessoa.present?

      criar_pessoa
    rescue ActiveRecord::RecordNotUnique
      Result.success(GPessoa.find_by!(cpf:), HttpStatus::OK, "Pessoa existente reutilizada com sucesso")
    end

    private

    attr_reader :g_pessoa_id, :g_pessoa_attributes, :atualizar_g_pessoa

    def resolve_por_id
      g_pessoa = GPessoa.find(g_pessoa_id)
      return failure("O CPF informado nao corresponde a pessoa selecionada") if cpf.present? && cpf != g_pessoa.cpf

      return Result.success(g_pessoa, HttpStatus::OK) unless atualizar_g_pessoa

      atualizar(g_pessoa, g_pessoa_attributes.except(:cpf))
    rescue ActiveRecord::RecordNotFound
      failure("Pessoa nao encontrada")
    end

    def atualizar_ou_reutilizar(g_pessoa)
      return Result.success(g_pessoa, HttpStatus::OK, "Pessoa existente reutilizada com sucesso") unless atualizar_g_pessoa

      atualizar(g_pessoa, g_pessoa_attributes)
    end

    def criar_pessoa
      g_pessoa = GPessoa.new(g_pessoa_attributes)
      return Result.success(g_pessoa, HttpStatus::CREATED, "Pessoa criada com sucesso") if g_pessoa.save

      failure(g_pessoa.errors.full_messages)
    end

    def atualizar(g_pessoa, attributes)
      return Result.success(g_pessoa, HttpStatus::OK, "Pessoa atualizada com sucesso") if g_pessoa.update(attributes)

      failure(g_pessoa.errors.full_messages)
    end

    def cpf
      @cpf ||= GPessoa.normalize_cpf(g_pessoa_attributes[:cpf])
    end

    def failure(error)
      Result.failure(error, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel resolver a pessoa")
    end
  end
end
