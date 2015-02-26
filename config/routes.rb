Rails.application.routes.draw do
  root to: proc { [200, {}, ['Pension Wise - Record of Guidance']] }

  constraints format: 'html' do
    scope path: 'styleguide', controller: 'styleguide' do
      scope path: 'pages' do
        get 'input', action: 'pages_input'
        get 'output', action: 'pages_output'
      end

      get '(/:action)'
    end
  end
end
