# frozen_string_literal: true

class GTipoInstrumentoBlueprint < ApplicationBlueprint
  identifier :id
  fields :codigo, :descricao, :ativo
  association :g_classificacao_instrumento, blueprint: GClassificacaoInstrumentoBlueprint
end
