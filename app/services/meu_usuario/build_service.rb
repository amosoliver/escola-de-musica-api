# frozen_string_literal: true

module MeuUsuario
  # Monta o retorno agregado de "meu usuario": dados basicos, e para cada
  # vinculo ativo (perfil dentro de uma unidade gestora) as permissoes do
  # perfil e os templates com seus sidebars/itens ja em arvore.
  class BuildService
    def self.call(user:)
      new(user:).call
    end

    def initialize(user:)
      @user = user
    end

    def call
      {
        usuario: dados_usuario,
        perfis: perfis_do_usuario
      }
    end

    private

    attr_reader :user

    def dados_usuario
      {
        id: user.id,
        cpf: user.cpf,
        email: user.email,
        nome: user.g_pessoa&.nome,
        primeiro_acesso: user.primeiro_acesso,
        data_ultimo_acesso: user.data_ultimo_acesso
      }
    end

    def perfis_do_usuario
      vinculos = user.users_perfis.where(ativo: true).includes(:u_perfil, :g_unidade_gestora)

      vinculos.map do |vinculo|
        perfil = vinculo.u_perfil

        {
          vinculo_id: vinculo.id,
          unidade_gestora: unidade_gestora_payload(vinculo.g_unidade_gestora),
          perfil: { id: perfil.id, codigo: perfil.codigo, descricao: perfil.descricao },
          permissoes: permissoes_do_perfil(perfil),
          templates: templates_do_perfil(perfil)
        }
      end
    end

    def unidade_gestora_payload(unidade)
      return nil unless unidade

      { id: unidade.id, nome: unidade.nome, tipo_unidade: unidade.tipo_unidade }
    end

    def permissoes_do_perfil(perfil)
      perfil.u_permissoes.where(ativo: true).distinct.map do |permissao|
        { id: permissao.id, codigo: permissao.codigo, modulo: permissao.modulo, acao: permissao.acao }
      end
    end

    def templates_do_perfil(perfil)
      UPerfilTemplate.where(u_perfil: perfil, ativo: true).includes(:u_template).map do |vinculo|
        template = vinculo.u_template

        {
          id: template.id,
          chave: template.chave,
          descricao: template.descricao,
          componente_layout: template.componente_layout,
          configuracao: template.configuracao,
          principal: vinculo.principal,
          sidebars: sidebars_do_template(template)
        }
      end
    end

    def sidebars_do_template(template)
      template.u_sidebars.where(ativo: true).map do |sidebar|
        {
          id: sidebar.id,
          chave: sidebar.chave,
          descricao: sidebar.descricao,
          posicao: sidebar.posicao,
          itens: arvore_de_itens(sidebar)
        }
      end
    end

    def arvore_de_itens(sidebar)
      itens = sidebar.u_sidebar_itens.where(ativo: true).includes(:u_rota).order(:ordem).to_a
      itens_por_pai = itens.group_by(&:u_sidebar_item_pai_id)

      filhos_de(nil, itens_por_pai)
    end

    def filhos_de(pai_id, itens_por_pai)
      (itens_por_pai[pai_id] || []).map do |item|
        {
          id: item.id,
          descricao: item.descricao,
          icone: item.icone,
          tipo: item.tipo,
          ordem: item.ordem,
          expandido_padrao: item.expandido_padrao,
          rota: rota_payload(item.u_rota),
          itens: filhos_de(item.id, itens_por_pai)
        }
      end
    end

    def rota_payload(rota)
      return nil unless rota

      { id: rota.id, nome_rota: rota.nome_rota, path: rota.path, componente: rota.componente }
    end
  end
end
