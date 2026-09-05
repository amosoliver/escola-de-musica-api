# frozen_string_literal: true

class PPatrimonioArquivoBlueprint < ApplicationBlueprint
  identifier :id
  fields :arquivo, :nome_original, :content_type, :tamanho_bytes, :observacao
  association :p_tipo_arquivo_patrimonio, blueprint: PTipoArquivoPatrimonioBlueprint
end
