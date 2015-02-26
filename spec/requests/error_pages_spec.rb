require 'rails_helper'

RSpec.describe 'Error pages', type: :request do
  describe 'when the resource does not exist' do
    specify ' a 404 page is rendered' do
      get '/non-existent-resource'

      expect(response).to be_not_found
      expect(response).to render_template(:not_found)
    end
  end
end
