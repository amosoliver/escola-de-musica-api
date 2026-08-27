Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :u_rotas
      resources :g_paises
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
    end
  end
end
