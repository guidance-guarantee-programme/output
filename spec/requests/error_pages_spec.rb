require 'rails_helper'

RSpec.describe 'Error pages', type: :request do
  describe 'when the resource does not exist' do
    specify 'a 404 page is rendered' do
      get '/non-existent-resource'

      expect(response).to be_not_found
      expect(response.body).to include('Please check that you entered the correct web address')
    end
  end
end
