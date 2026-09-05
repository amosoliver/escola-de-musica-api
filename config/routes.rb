Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      post "login", to: "sessions#create"
      post "refresh", to: "sessions#refresh"
      delete "logout", to: "sessions#destroy"
      get "meu_usuario", to: "meu_usuario#show"

      resources :u_rotas
      resources :g_alergias
      resources :g_paises
      resources :g_parentescos
      resources :g_necessidades_especificas
      resources :e_responsaveis
      resources :e_saudes_estudantes
      resources :e_estudantes
      resources :r_tipos_vinculos
      resources :r_especialidades
      resources :r_funcoes
      resources :r_setores
      resources :r_setores_funcoes
      resources :r_funcionarios
      resources :u_rotas_permissoes
      resources :u_sidebar_itens
      resources :u_sidebars
      resources :u_perfis_templates
      resources :u_templates
      resources :u_perfis_permissoes
      resources :users_perfis
      resources :i_ambientes_prediais
      resources :i_blocos
      resources :i_predios
      resources :i_predios, only: [] do
        resources :g_andares, only: :index, controller: "g_andares" do
          resources :i_blocos, except: %i[new edit], controller: "i_blocos"
        end
      end
      resources :i_blocos, only: [] do
        resources :i_ambientes_prediais, except: %i[new edit], controller: "i_ambientes_prediais"
      end
      resources :u_permissoes
      resources :u_perfis
      resources :g_pessoas
      resources :g_bairros
      resources :g_cidades
      resources :g_sexos
      resources :g_tipos_ambientes_prediais
      resources :g_andares
      resources :g_situacoes_predios
      resources :g_tipos_predios
      resources :g_unidades_gestoras
      resources :p_situacoes_patrimonios
      resources :p_estados_conservacoes_patrimonios
      resources :p_tipos_aquisicoes_patrimonios
      resources :p_tipos_arquivos_patrimonios
      resources :p_tipos_movimentacoes_patrimonios
      resources :p_status_emprestimos_patrimonios
      resources :p_tipos_manutencoes_patrimonios
      resources :p_status_manutencoes_patrimonios
      resources :p_tipos_baixas_patrimonios

      resources :g_classificacoes_instrumentos
      resources :g_tipos_instrumentos
      resources :g_instrumentos
      resources :g_categorias_patrimonios
      resources :g_tipos_patrimonios

      resources :p_destinos_externos

      resources :p_patrimonios do
        member do
          post :transferir
          post :vender
          post :doar
          post :descartar
        end
        resources :p_patrimonios_responsaveis, only: %i[index create], controller: "p_patrimonios_responsaveis"
        resources :p_patrimonios_arquivos, only: %i[index create destroy], controller: "p_patrimonios_arquivos"
      end

      resources :p_movimentacoes_patrimonios, only: %i[index show]

      resources :p_manutencoes_patrimonios, only: %i[index show create] do
        member do
          post :aprovar
          post :agendar
          post :iniciar
          post :concluir
          post :cancelar
        end
      end

      resources :p_baixas_patrimonios, only: %i[index show]

      resources :p_emprestimos, only: %i[index show create] do
        resources :p_devolucoes, only: %i[index show create]
      end

      resources :p_inventarios, only: %i[index show create] do
        member { post :encerrar }
        resources :p_inventarios_itens, only: %i[index update]
      end
    end
  end
end
