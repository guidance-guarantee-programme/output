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

  resources :appointment_summaries, only: %i(new create show)

  scope path: 'styleguide', controller: 'styleguide' do
    scope path: 'pages' do
      get 'input', action: 'pages_input'
      get 'input-v2', action: 'pages_input_v2'
      get 'output', action: 'pages_output'
      get 'output-v2', action: 'pages_output_v2'
    end

    get '(/:action)'
  end

  mount Sidekiq::Web => '/sidekiq'
end
