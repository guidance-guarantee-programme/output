Rails.application.routes.draw do
  root 'appointment_summaries#new'

  constraints format: 'html' do
    resources :appointment_summaries, only: %i(new create)

    scope path: 'styleguide', controller: 'styleguide' do
      scope path: 'pages' do
        get 'input', action: 'pages_input'
        get 'output', action: 'pages_output'
      end

      get '(/:action)'
    end
  end
end
