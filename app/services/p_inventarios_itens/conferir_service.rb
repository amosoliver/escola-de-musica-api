# frozen_string_literal: true

module PInventariosItens
  # Registra a conferencia de um item do inventario: se foi encontrado, em qual
  # ambiente e em que estado de conservacao. localizacao_divergente e calculado
  # automaticamente comparando o ambiente informado com o ambiente atual do
  # patrimonio.
  class ConferirService
    def self.call(p_inventario_item:, params:)
      new(p_inventario_item:, params:).call
    end

    def initialize(p_inventario_item:, params:)
      @p_inventario_item = p_inventario_item
      @params = params
    end

    def call
      atributos = {
        encontrado: params.fetch(:encontrado, p_inventario_item.encontrado),
        i_ambiente_predial_encontrado_id: params[:i_ambiente_predial_encontrado_id],
        p_estado_conservacao_patrimonio_id: params[:p_estado_conservacao_patrimonio_id],
        observacao: params[:observacao],
        localizacao_divergente: divergente?(params[:i_ambiente_predial_encontrado_id]),
        conferido_em: Time.current
      }

      return Result.success(p_inventario_item, HttpStatus::OK, "Item conferido com sucesso") if p_inventario_item.update(atributos)

      Result.failure(p_inventario_item.errors.full_messages, HttpStatus::UNPROCESSABLE_ENTITY, "Nao foi possivel conferir o item")
    end

    private

    attr_reader :p_inventario_item, :params

    def divergente?(i_ambiente_predial_encontrado_id)
      return false if i_ambiente_predial_encontrado_id.blank?

      i_ambiente_predial_encontrado_id.to_i != p_inventario_item.p_patrimonio.i_ambiente_predial_id
    end
  end
end
