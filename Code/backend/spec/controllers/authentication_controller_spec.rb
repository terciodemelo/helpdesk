require 'rails_helper'

def authenticate(user)
  token = JsonWebToken.encode({user_id: user.id})
  @request.headers['Authorization'] = "Bearer #{token}"
end

RSpec.describe AuthenticationController, type: :controller do
  
  describe "POST #authenticate_user" do
    context "Authenticate Existing User" do
      before :each do
        user = create :admin
        data = {email: user.email, password: user.password}
        post :authenticate_user, {params: data}
        @json_body = JSON.parse(response.body)
      end

      it "expect response to be a json" do
        expect(@json_body).to be_a(Hash)
      end

      it "expects json response to have an auth_token" do
        expect(@json_body.has_key? 'auth_token').to be_truthy
      end

      it "auth_token must be a string" do
        expect(@json_body['auth_token']).to be_a(String)
      end
    end
  end

  describe "GET #ping" do
    context "Authenticated" do
      before :each do
        @user = create :admin
        authenticate(@user)
        get :ping
        @json_body = JSON.parse(response.body)
      end

      it "must be authorized and to access a protected resource" do
        expect(response).to have_http_status(:success)
      end

      it "must be logged in" do
        expect(@json_body['logged_in']).to eq(true)
      end
    end

    context "Unauthenticated" do
      before :each do
        get :ping
      end

      it "expects to be unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
