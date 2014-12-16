require 'rails_helper'

describe V1::AuthenticationsController do
  render_views

  let(:user) { create(:user, password: 'hello123', password_confirmation: 'hello123') }
  let!(:authentication) { create(:authentication) }

  describe "POST 'create'" do
    context 'email and password' do
      it 'creates an authentication_token response if the email and password is valid' do
        post :create, user: { email: user.email, password: 'hello123' }
        
        expect(response.body).to be == { user: { id: user.id.to_s, email: user.email, authentication_token: user.authentication_token } }.to_json
      end

      it 'returns 401 if the password is invalid' do
        post :create, user: { email: user.email, password: 'hello' }
        
        expect(response.body).to be == { status: 401, error: ['unauthorized access'] }.to_json
      end

      it 'returns 404 if the email or password isnt present' do
        post :create, user: { password: 'hello123' }
        expect(response.body).to be == { status: 401, error: ['unauthorized access'] }.to_json
      end
    end

    context 'fb_login' do
      it 'creates an authentication_token response + updates authentcation if the access_token is valid and user exists' do                
        fb_user = double()
        expect(fb_user).to receive(:identifier) { authentication.uid }
        expect(fb_user).to receive(:access_token) { 'newtoken' }

        allow(FbGraph::User).to receive_message_chain(:me, :fetch).and_return(fb_user)

        expect{
          post :create, user: { fb_access_token: 'validtoken' }
        }.to change{ User.count }.by(0)

        expect(response.body).to be == { user: { id: authentication.user.id.to_s, email: authentication.user.email, authentication_token: authentication.user.authentication_token } }.to_json

      end

      it 'creates an authentication_token response + new user + new authentication if the access_token is valid and user doesnt exist' do
        fb_user = double()
        email = Faker::Internet.email
        expect(fb_user).to receive(:identifier).at_least(:once) { 'new_fb_id' }
        expect(fb_user).to receive(:access_token) { 'newtoken' }
        expect(fb_user).to receive(:email).at_least(:once) { email }
        expect(fb_user).to receive(:gender) { 'female' }
        expect(fb_user).to receive(:first_name) { Faker::Name.first_name }
        expect(fb_user).to receive(:last_name) { Faker::Name.last_name }

        allow(FbGraph::User).to receive_message_chain(:me, :fetch).and_return(fb_user)

        expect{
          post :create, user: { fb_access_token: 'validtoken' }
        }.to change{ User.count }.by(1)

        user = User.find_by(email: email)

        expect(response.body).to be == { user: { id: user.id.to_s, email: user.email, authentication_token: user.authentication_token } }.to_json        
      end

      it 'returns 401 if the access_token is invalid' do
        post :create, user: { fb_access_token: 'hello123' }

        expect(response.body).to be == { status: 401, error: ['unauthorized fb access'] }.to_json
      end
    end
  end
end