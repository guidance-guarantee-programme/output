require 'sidekiq/api'
require 'sidekiq/web'

Rails.application.routes.draw do
  root 'appointment_summaries#new'

  mount GovukAdminTemplate::Engine, at: '/style-guide'
  mount Sidekiq::Web => '/sidekiq', constraints: AuthenticatedUser.new

  resources :appointment_summaries, only: %i(index new create update show) do
    collection do
      get :creating
      get :done
      post :preview
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
end
