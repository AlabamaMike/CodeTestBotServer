CodeTestBotServer::Application.routes.draw do
  resources :candidates
  resources :sessions, only: [:new, :show]
  resources :submissions, except: [:new, :edit]
  resources :assessments, except: [:new, :edit]
  resources :levels, only: [:index]
  resources :languages, only: [:index]
  resources :roles
  resources :users
  post '/users/assign_role_to_user', to: 'users#assign_role_to_user'
  post '/users/remove_role_from_user', to: 'users#remove_role_from_user'
  get '/users/filter_by_role', to: 'users#filter_by_role'

  get '/auth/google/callback', to: 'omniauth_callbacks#google'
  get '/auth/development_token', to: 'omniauth_callbacks#development_token'

end
