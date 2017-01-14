require 'rails_helper'

def login(user)
	token = JsonWebToken.encode({user_id: user.id})
	@request.headers['Authorization'] = "Bearer #{token}"
end

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

		context "Authenticated" do
			context "as Admin" do
				before :each do
					login(create :admin)

					(0...3).each do |num|
						create :support_agent
						create :customer
						create :admin
					end

					get :index
				end

				it "has access to resource" do
					expect(response).to have_http_status(:success)
				end

				it "fetches ten users" do
					expect(JSON.parse(response.body).size).to eq(10)
				end
			end

			context "not as Admin" do
				before :each do
					login(create :support_agent)

					(0...3).each do |num|
						create :support_agent
						create :customer
						create :admin
					end

					get :index
				end

				it "has access to resource" do
					expect(response).to have_http_status(:success)
				end

				it "fetches ten users" do
					expect(JSON.parse(response.body).size).to eq(10)
				end
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

		context "Authenticated" do
			context "as Admin" do
				before :each do
					@users = (0...5).map do |n| 
						create [:customer, :support_agent, :admin].sample
					end

					login(create :admin)
					get :show, params: {id: @users.sample.id}
				end

				it "fetchs an existing user successfully" do
					expect(response).to have_http_status(:success)
				end

				it "the response must be a json" do
					expect(response.content_type).to eq('application/json')
				end

				it "the json response must not contain user's password" do
					expect(JSON.parse(response.body).has_key? 'password').to eq(false)
				end

				it "the json response must contain user's name and email only" do
					expect(JSON.parse(response.body).has_key? 'name').to eq(true)
					expect(JSON.parse(response.body).has_key? 'email').to eq(true)
				end
			end

			context "not as Admin" do
				before :each do
					@users = (0...5).map do |n| 
						create [:customer, :support_agent, :admin].sample
					end

					login(create [:support_agent, :customer].sample)
					get :show, params: {id: @users.sample.id}
				end

				it "fetchs an existing user successfully" do
					expect(response).to have_http_status(:success)
				end

				it "the response must be a json" do
					expect(response.content_type).to eq('application/json')
				end

				it "the json response must not contain user's password" do
					expect(JSON.parse(response.body).has_key? 'password').to eq(false)
				end

				it "the json response must contain user's name and email only" do
					expect(JSON.parse(response.body).has_key? 'name').to eq(true)
					expect(JSON.parse(response.body).has_key? 'email').to eq(true)
				end
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

		context "Authenticated" do
			context "as Admin" do
				before :each do
					login(create :admin)
				end

				context "creation of Customer" do
					before :each do
						post :create, {params: {user: build(:create_customer_params)}}
					end

					it "successfully creates a Customer" do
						expect(response).to have_http_status(:created)
					end
				end

				context "creation of SupportAgent" do
					before :each do
						post :create, {params: {user: build(:create_support_agent_params)}}
					end

					it "successfully creates a SupportAgent" do
						expect(response).to have_http_status(:created)
					end
				end

				context "creation of Admin" do
					before :each do
						post :create, {params: {user: build(:create_admin_params)}}
					end

					it "successfully creates a Admin" do
						expect(response).to have_http_status(:created)
					end
				end
			end

			context "not as Admin" do
				before :each do
					login create([:customer, :support_agent].sample)
				end

				context "creation of Customer" do
					before :each do
						post :create, {params: {user: build(:create_customer_params)}}
					end

					it "fails to create a Customer" do
						expect(response).to have_http_status(:unauthorized)
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

		context "Authenticated" do
			context "as Admin" do
				before :each do
					login(create :admin)
				end

				context "update of Customer" do
					before :each do
						user = create :customer
						put :update, {params: {
							id: user.id,
							user: build(:create_customer_params)
						}}
					end

					it "successfully updates a Customer" do
						expect(response).to have_http_status(:success)
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

					it "successfully updates a SupportAgent" do
						expect(response).to have_http_status(:success)
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

					it "successfully updates a Admin" do
						expect(response).to have_http_status(:success)
					end
				end
			end

			context "as Support" do
				before :each do
					@user = create :support_agent
					login(@user)
				end

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

				context "update of other SupportAgent" do
					before :each do
						user = create :support_agent
						put :update, {params: {
							id: user.id,
							user: build(:create_support_agent_params)
						}}
					end

					it "fails to update other SupportAgent" do
						expect(response).to have_http_status(:unauthorized)
					end
				end

				context "update of their own data" do
					before :each do
						user_attributes = build :support_agent

						put :update, {params: {
							id: @user.id,
							user: user_attributes.attributes
						}}
					end

					it "successfully updates data" do
						expect(response).to have_http_status(:success)
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

					it "successfully updates a Admin" do
						expect(response).to have_http_status(:unauthorized)
					end
				end
			end

			context "as Customer" do
				before :each do
					@user = create :customer
					login(@user)
				end

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

				context "update of other SupportAgent" do
					before :each do
						user = create :support_agent
						put :update, {params: {
							id: user.id,
							user: build(:create_support_agent_params)
						}}
					end

					it "fails to update other SupportAgent" do
						expect(response).to have_http_status(:unauthorized)
					end
				end

				context "update of their own data" do
					before :each do
						user_attributes = build :customer

						put :update, {params: {
							id: @user.id,
							user: user_attributes.attributes
						}}
					end

					it "successfully updates data" do
						expect(response).to have_http_status(:success)
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

					it "successfully updates a Admin" do
						expect(response).to have_http_status(:unauthorized)
					end
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

	context "Authenticated" do
		context "as Admin" do
			before :each do
				login(create :admin)
			end

			context "deletion of Customer" do
				before :each do
					user = create :customer
					delete :destroy, {params: { id: user.id }}
				end

				it "successfully deletes a Customer" do
					expect(response).to have_http_status(:success)
				end
			end

			context "deletion of SupportAgent" do
				before :each do
					user = create :support_agent
					delete :destroy, {params: { id: user.id }}
				end

				it "successfully deletes a SupportAgent" do
					expect(response).to have_http_status(:success)
				end
			end

			context "deletion of Admin" do
				before :each do
					user = create :admin
					delete :destroy, {params: { id: user.id }}
				end

				it "successfully deletes a Admin" do
					expect(response).to have_http_status(:success)
				end
			end
		end

		context "as Support" do
			before :each do
				@user = create :support_agent
				login(@user)
			end

			context "deletion of Customer" do
				before :each do
					user = create :customer
					delete :destroy, {params: { id: user.id }}
				end

				it "fails to delete a Customer" do
					expect(response).to have_http_status(:unauthorized)
				end
			end

			context "deletion of other SupportAgent" do
				before :each do
					user = create :support_agent
					delete :destroy, {params: { id: user.id }}
				end

				it "fails to delete other SupportAgent" do
					expect(response).to have_http_status(:unauthorized)
				end
			end

			context "deletion of their own data" do
				before :each do
					user_attributes = build :support_agent

					delete :destroy, {params: { id: @user.id }}
				end

				it "fails to destroy data" do
					expect(response).to have_http_status(:unauthorized)
				end
			end

			context "deletion of Admin" do
				before :each do
					user = create :admin
					delete :destroy, {params: { id: user.id }}
				end

				it "fails to delete a Admin" do
					expect(response).to have_http_status(:unauthorized)
				end
			end
		end

		context "as Customer" do
			before :each do
				@user = create :customer
				login(@user)
			end

			context "deletion of Customer" do
				before :each do
					user = create :customer
					delete :destroy, {params: { id: user.id }}
				end

				it "fails to delete a Customer" do
					expect(response).to have_http_status(:unauthorized)
				end
			end

			context "deletion of other SupportAgent" do
				before :each do
					user = create :support_agent
					delete :destroy, {params: { id: user.id }}
				end

				it "fails to delete other SupportAgent" do
					expect(response).to have_http_status(:unauthorized)
				end
			end

			context "deletion of their own data" do
				before :each do
					user_attributes = build :customer

					delete :destroy, {params: { id: @user.id }}
				end

				it "fails deletes data" do
					expect(response).to have_http_status(:unauthorized)
				end
			end

			context "deletion of Admin" do
				before :each do
					user = create :admin
					delete :destroy, {params: { id: user.id }}
				end

				it "fails to delete a Admin" do
					expect(response).to have_http_status(:unauthorized)
				end
			end
		end
	end
end
