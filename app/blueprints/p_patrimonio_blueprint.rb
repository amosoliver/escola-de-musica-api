# frozen_string_literal: true

class PPatrimonioBlueprint < ApplicationBlueprint
  identifier :id
  fields :codigo_patrimonial, :codigo_barras, :qr_code, :descricao, :marca, :modelo, :numero_serie,
         :data_aquisicao, :data_garantia_fim, :valor_aquisicao, :observacao, :ativo

  association :g_unidade_gestora, blueprint: GUnidadeGestoraSummaryBlueprint
  association :g_instrumento, blueprint: GInstrumentoBlueprint
  association :g_tipo_patrimonio, blueprint: GTipoPatrimonioBlueprint
  association :i_ambiente_predial, blueprint: IAmbientePredialBlueprint
  association :p_estado_conservacao_patrimonio, blueprint: PEstadoConservacaoPatrimonioBlueprint
  association :p_situacao_patrimonio, blueprint: PSituacaoPatrimonioBlueprint
  association :p_tipo_aquisicao_patrimonio, blueprint: PTipoAquisicaoPatrimonioBlueprint
  association :p_patrimonios_arquivos, blueprint: PPatrimonioArquivoBlueprint
  association :p_patrimonios_responsaveis, blueprint: PPatrimonioResponsavelBlueprint
end
