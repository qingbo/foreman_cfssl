Rails.application.routes.draw do
  get 'new_action', to: 'foreman_cfssl/hosts#new_action'
end
