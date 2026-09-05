# frozen_string_literal: true

module PPatrimoniosArquivos
  class CreateService
    def self.call(p_patrimonio:, params:)
      new(p_patrimonio:, params:).call
    end

    def initialize(p_patrimonio:, params:)
      @p_patrimonio = p_patrimonio
      @params = params
    end

    def call
      arquivo = p_patrimonio.p_patrimonios_arquivos.new(params)
      return Result.success(arquivo, HttpStatus::CREATED, "Arquivo anexado com sucesso") if arquivo.save

      Result.failure(arquivo.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel anexar o arquivo")
    end

    private

    attr_reader :p_patrimonio, :params
  end
end
