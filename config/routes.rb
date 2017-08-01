Rails.application.routes.draw do
  get '/certs', to: 'foreman_cfssl/certs#index', as: :index
  get '/certs/import', to: 'foreman_cfssl/certs#import', as: :import
  post '/certs/import', to: 'foreman_cfssl/certs#import_save'
  get '/certs/new', to: 'foreman_cfssl/certs#new'
  post '/certs', to: 'foreman_cfssl/certs#create'
  get '/certs/:id', to: 'foreman_cfssl/certs#show', as: :foreman_cfssl_cert # for easier link_to
  delete '/certs/:id', to: 'foreman_cfssl/certs#destroy'
end
