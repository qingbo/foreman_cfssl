Rails.application.routes.draw do
  get '/certs', to: 'foreman_cfssl/certs#index'
  get '/certs/new', to: 'foreman_cfssl/certs#new'
  post '/certs', to: 'foreman_cfssl/certs#create'
  get '/certs/:id', to: 'foreman_cfssl/certs#show'
end
