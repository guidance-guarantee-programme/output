Rails.application.routes.draw do
  root to: proc { [200, {}, ['Pension Wise - Record of Guidance']] }
end
