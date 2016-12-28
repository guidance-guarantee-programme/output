require 'sidekiq/api'
require 'sidekiq/web'

if ENV['SIDEKIQ_USERNAME'] && ENV['SIDEKIQ_PASSWORD']
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV['SIDEKIQ_USERNAME'] && password == ENV['SIDEKIQ_PASSWORD']
  end
end

Rails.application.routes.draw do
  root 'appointment_summaries#new'

  mount GovukAdminTemplate::Engine, at: '/style-guide'

  resources :appointment_summaries, only: %i(index new create show) do
    collection do
      get :creating
      get :done
      post :preview
      post :email_confirmation
    end
  end

  scope path: 'styleguide', controller: 'styleguide' do
    scope path: 'pages' do
      get 'input', action: 'pages_input'
      get 'output-elements', action: 'pages_output_elements'
    end
  end

  namespace :admin do
    resources :appointment_summaries, only: [:index, :edit, :update]
  end

  mount Sidekiq::Web => '/sidekiq'
end
