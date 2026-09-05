# frozen_string_literal: true

module PPatrimoniosArquivos
  class DestroyService
    def self.call(p_patrimonio_arquivo:)
      new(p_patrimonio_arquivo:).call
    end

    def initialize(p_patrimonio_arquivo:)
      @p_patrimonio_arquivo = p_patrimonio_arquivo
    end

    def call
      return Result.success(nil, HttpStatus::NO_CONTENT, "Arquivo removido com sucesso") if p_patrimonio_arquivo.destroy

      Result.failure(p_patrimonio_arquivo.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel remover o arquivo")
    end

    private

    attr_reader :p_patrimonio_arquivo
  end
end
