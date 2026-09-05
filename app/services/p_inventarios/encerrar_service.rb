# frozen_string_literal: true

module PInventarios
  class EncerrarService
    def self.call(p_inventario:)
      new(p_inventario:).call
    end

    def initialize(p_inventario:)
      @p_inventario = p_inventario
    end

    def call
      return ja_encerrado if p_inventario.encerrado?

      if p_inventario.update(encerrado: true, data_fim: Time.current)
        return Result.success(p_inventario, HttpStatus::OK, "Inventario encerrado com sucesso")
      end

      Result.failure(p_inventario.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel encerrar o inventario")
    end

    private

    attr_reader :p_inventario

    def ja_encerrado
      Result.failure([ "Inventario ja esta encerrado" ], HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel encerrar o inventario")
    end
  end
end
