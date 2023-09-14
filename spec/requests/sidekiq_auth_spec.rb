require 'rails_helper'

RSpec.describe 'Sidekiq control panel' do
  scenario 'requires authentication' do
    with_real_sso do
      when_they_visit_the_sidekiq_panel
      then_the_existence_of_the_route_is_never_leaked
    end
  end

  scenario 'successfully authenticating' do
    given_a_user do
      when_they_visit_the_sidekiq_panel
      then_they_are_authenticated
    end
  end

  def when_they_visit_the_sidekiq_panel
    get '/sidekiq'
  end

  def then_the_existence_of_the_route_is_never_leaked
    expect(response).to be_not_found
  end

  def then_they_are_authenticated
    expect(response).to be_ok
  end
end
