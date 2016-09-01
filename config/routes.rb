# frozen_string_literal: true
require 'sidekiq/api'
require 'sidekiq/web'

Sidekiq::Web.get '/rag' do
  stats = Sidekiq::Stats.new

  content_type :json

  { item: [{ value: stats.failed, text: 'Failed' },
           { value: stats.enqueued, text: 'Enqueued' },
           { value: stats.processed, text: 'Processed' }] }.to_json
end

if ENV['SIDEKIQ_USERNAME'] && ENV['SIDEKIQ_PASSWORD']
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['SIDEKIQ_USERNAME'] && password == ENV['SIDEKIQ_PASSWORD']
  end
end

Rails.application.routes.draw do
  root 'appointment_summaries#new'

  mount GovukAdminTemplate::Engine, at: '/style-guide'

  devise_for :users
  as :user do
    scope path: 'users', controller: 'devise/registrations' do
      get 'edit', action: 'edit', as: 'edit_user_registration'
      put ':id', action: 'update', as: 'user_registration'
    end
  end

  resources :appointment_summaries, only: %i(index new create) do
    post :preview, on: :collection
    post :email_confirmation, on: :collection
  end

  scope path: 'styleguide', controller: 'styleguide' do
    scope path: 'pages' do
      get 'input', action: 'pages_input'
      get 'output-elements', action: 'pages_output_elements'
    end

    get '(/:action)'
  end

  namespace :admin do
    resources :appointment_summaries, only: [:index, :edit, :update]
  end

  mount Sidekiq::Web => '/sidekiq'
end
