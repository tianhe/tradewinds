require 'rails_helper'

describe V1::ApiController do  
  let(:user) { FactoryGirl.create(:user) }

  describe 'authenticate_user_from_token' do
    it 'should sign in user if email and authentication is present and correct' do
      controller.params = {email: user.email, authentication_token: user.authentication_token}
      controller.authenticate_user_from_token! 
      expect(response).to be_success
    end
  end
end