require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #index" do
    context "Unauthenticated" do
      before :each do
        (0...3).each do |num|
          create :support_agent
          create :customer
          create :admin
        end

        get :index
      end

      it "doesn't have access to users listing" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET #show" do
    context "Unauthenticated" do
      before :each do
        @users = (0...5).map do |n| 
          create [:customer, :support_agent, :admin].sample
        end

        get :show, params: {id: @users.sample.id}
      end

      it "doesn't have access to user details" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST #create" do
    context "Unauthenticated" do
      context "creation of Customer" do
        before :each do
          post :create, {params: {user: build(:create_customer_params)}}
        end

        it "has no authorization header" do
          expect(@request.headers['Authorization']).to be_nil
        end

        it "successfully creates a Customer" do
          expect(response).to have_http_status(:created)
        end
      end

      context "creation of SupportAgent" do
        before :each do
          post :create, {params: {user: build(:create_support_agent_params)}}
        end

        it "fails to create a SupportAgent" do
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context "creation of Admin" do
        before :each do
          post :create, {params: {user: build(:create_admin_params)}}
        end

        it "fails to create a Admin" do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe "PUT #update" do
    context "Unauthenticated" do
      context "update of Customer" do
        before :each do
          user = create :customer
          put :update, {params: {
            id: user.id,
            user: build(:create_customer_params)
          }}
        end

        it "fails to update a Customer" do
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context "update of SupportAgent" do
        before :each do
          user = create :support_agent
          put :update, {params: {
            id: user.id,
            user: build(:create_support_agent_params)
          }}
        end

        it "fails to update a SupportAgent" do
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context "update of Admin" do
        before :each do
          user = create :admin
          put :update, {params: {
            id: user.id,
            user: build(:create_admin_params)
          }}
        end

        it "fails to update a Admin" do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "Unauthenticated" do
      context "deletion of Customer" do
        before :each do
          user = create :customer
          delete :destroy, {params: {id: user.id}}
        end

        it "fails to delete a Customer" do
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context "delete of SupportAgent" do
        before :each do
          user = create :support_agent
          delete :destroy, {params: {id: user.id}}
        end

        it "fails to delete a SupportAgent" do
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context "deletion of Admin" do
        before :each do
          user = create :admin
          delete :destroy, {params: {id: user.id}}
        end

        it "fails to delete a Admin" do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
