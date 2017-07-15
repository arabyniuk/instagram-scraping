Rails.application.routes.draw do
  get '/callback' => 'auth#callback'
  get '/get_access_token' => 'auth#get_access_token'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
