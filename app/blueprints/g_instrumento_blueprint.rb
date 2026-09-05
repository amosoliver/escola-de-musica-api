# frozen_string_literal: true

class GInstrumentoBlueprint < ApplicationBlueprint
  identifier :id
  fields :codigo, :descricao, :ativo
  association :g_tipo_instrumento, blueprint: GTipoInstrumentoBlueprint
end
