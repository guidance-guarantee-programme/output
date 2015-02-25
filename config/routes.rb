Rails.application.routes.draw do
  root to: proc { [200, {}, ['Pension Wise - Record of Guidance']] }

  constraints format: 'html' do
    scope path: 'styleguide', controller: 'styleguide' do
      get '(/:action)'
    end
  end
end
