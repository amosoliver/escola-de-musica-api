# frozen_string_literal: true

module PDestinosExternos
  # Resolve um destino externo existente (por id) ou cria um novo a partir dos
  # atributos informados, reaproveitado pelos fluxos de movimentacao, manutencao
  # e baixa de patrimonio que podem selecionar ou cadastrar o destino na hora.
  class ResolverService
    def self.call(g_unidade_gestora_id:, p_destino_externo_id: nil, p_destino_externo_attributes: nil)
      new(g_unidade_gestora_id:, p_destino_externo_id:, p_destino_externo_attributes:).call
    end

    def initialize(g_unidade_gestora_id:, p_destino_externo_id:, p_destino_externo_attributes:)
      @g_unidade_gestora_id = g_unidade_gestora_id
      @p_destino_externo_id = p_destino_externo_id
      @p_destino_externo_attributes = p_destino_externo_attributes
    end

    def call
      return Result.success(nil) if p_destino_externo_id.blank? && p_destino_externo_attributes.blank?
      return buscar_existente if p_destino_externo_id.present?

      criar_novo
    end

    private

    attr_reader :g_unidade_gestora_id, :p_destino_externo_id, :p_destino_externo_attributes

    def buscar_existente
      destino = PDestinoExterno.find_by(id: p_destino_externo_id, g_unidade_gestora_id: g_unidade_gestora_id)
      return Result.failure([ "Destino externo nao encontrado" ], HttpStatus::UNPROCESSABLE_ENTITY, "Destino externo nao encontrado") if destino.blank?

      Result.success(destino)
    end

    def criar_novo
      destino = PDestinoExterno.new(p_destino_externo_attributes.merge(g_unidade_gestora_id: g_unidade_gestora_id))
      return Result.success(destino) if destino.save

      Result.failure(destino.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel cadastrar destino externo")
    end
  end
end
