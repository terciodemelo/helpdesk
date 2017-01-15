require 'rails_helper'

def login(user)
  token = JsonWebToken.encode({user_id: user.id})
  @request.headers['Authorization'] = "Bearer #{token}"
end

RSpec.describe TicketResponsesController, type: :controller do

  describe "GET #index" do
    context "Unauthenticated" do
      before :each do
        ticket = create :ticket
        create_list :ticket_response, 9, ticket: ticket

        get :index, params: {ticket_id: ticket.id}
      end

      it "doesn't have access to resource" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "Authenticated" do
      context "as Admin" do
        before :each do
          login(create :admin)

          ticket = create :ticket
          create_list :ticket_response, 9, ticket: ticket
          create_list :ticket_response, 5

          get :index, params: {ticket_id: ticket.id}
        end

        it "has access to resource" do
          expect(response).to have_http_status(:success)
        end

        it "fetches nine ticket_responses" do
          expect(JSON.parse(response.body).size).to eq(9)
        end
      end

      context "as SupportAgent" do
        before :each do
          login(create :support_agent)

          ticket = create :ticket
          create_list :ticket_response, 9, ticket: ticket

          get :index, params: {ticket_id: ticket.id}
        end

        it "has access to resource" do
          expect(response).to have_http_status(:success)
        end

        it "fetches ten ticket_responses" do
          expect(JSON.parse(response.body).size).to eq(9)
        end
      end

      context "as Customer" do
        before :each do
          @user = create :customer
          login(@user)
        end

        context "accessing other's tickets ticket_responses" do
          before :each do
            ticket = create :ticket
            create_list :ticket_response, 9, ticket: ticket
            get :index, params: {ticket_id: ticket.id}
          end

          it "hasn't access to resource" do
            expect(response).to have_http_status(:unauthorized)
          end
        end

        context "accessing their own tickets ticket_responses" do
          before :each do
            ticket = create :ticket, author: @user
            create_list :ticket_response, 9, ticket: ticket
            get :index, params: {ticket_id: ticket.id}
          end
          it "has access to resource" do
            expect(response).to have_http_status(:success)
          end

          it "fetches nine ticket_responses" do
            expect(JSON.parse(response.body).size).to eq(9)
          end
        end
      end
    end
  end

  describe "GET #show" do
    context "Unauthenticated" do
      before :each do
        @ticket = create :ticket
        @ticket_responses = create_list :ticket_response, 5, ticket: @ticket
      end

      it "cannot fetch an existing ticket ticket_response" do
        get :show, params: {ticket_id: @ticket.id, id: @ticket_responses.sample.id}
        expect(response).to have_http_status(:unauthorized)
      end

      it "cannot fetch an non-existing ticket ticket_response" do
        get :show, params: {ticket_id: -1, id: -1}
        expect(response).to have_http_status(:not_found)
      end
    end

    context "Authenticated" do
      context "as Admin" do
        before :each do
          login(create :admin)
        end

        context "existing ticket ticket_response" do
          before :each do
            ticket = create :ticket
            ticket_responses = create_list :ticket_response, 5, ticket: ticket
            get :show, params: {ticket_id: ticket.id, id: ticket_responses.sample.id}
          end

          it "fetchs an existing ticket ticket_response successfully" do
            expect(response).to have_http_status(:success)
          end

          it "the response must be a json" do
            expect(response.content_type).to eq('application/json')
          end

          it "the response must contain a body" do
            expect(JSON.parse(response.body)['body']).to be_a(String)
          end
        end

        context "non-existing ticket ticket_response" do
          before :each do
            ticket = create :ticket
            ticket_responses = create_list :ticket_response, 5, ticket: ticket
            get :show, params: {ticket_id: -1, id: -1}
          end

          it "cannot fetch non-existing ticket successfully" do
            expect(response).to have_http_status(:not_found)
          end
        end
      end

      context "as a SupportAgent" do
        before :each do
          login(create :support_agent)
        end

        context "existing ticket ticket_response" do
          before :each do
            ticket = create :ticket
            ticket_responses = create_list :ticket_response, 5, ticket: ticket
            get :show, params: {ticket_id: ticket.id, id: ticket_responses.sample.id}
          end

          it "fetchs an existing ticket ticket_response successfully" do
            expect(response).to have_http_status(:success)
          end

          it "the response must be a json" do
            expect(response.content_type).to eq('application/json')
          end

          it "the response must contain a body" do
            expect(JSON.parse(response.body)['body']).to be_a(String)
          end
        end

        context "non-existing ticket ticket_response" do
          before :each do
            ticket = create :ticket
            ticket_responses = create_list :ticket_response, 5, ticket: ticket
            get :show, params: {ticket_id: -1, id: -1}
          end

          it "cannot fetch non-existing ticket successfully" do
            expect(response).to have_http_status(:not_found)
          end
        end
      end

      context "as a Customer" do
        before :each do
          @user = create :customer
          login(@user)
        end

        context "non-existing ticket ticket_response" do
          before :each do
            ticket = create :ticket, author: @user
            get :show, params: {ticket_id: ticket.id, id: -1}
          end

          it "cannot fetch non-existing ticket successfully" do
            expect(response).to have_http_status(:not_found)
          end
        end

        context "accessing their own tickets ticket_response" do
          before :each do
            ticket = create :ticket, author: @user
            ticket_response = create :ticket_response, ticket: ticket
            get :show, params: {ticket_id: ticket.id, id: ticket_response.id}
          end

          it "fetchs an existing ticket successfully" do
            expect(response).to have_http_status(:success)
          end

          it "the response must be a json" do
            expect(response.content_type).to eq('application/json')
          end

          it "the response must contain a body" do
            expect(JSON.parse(response.body)['body']).to be_a(String)
          end
        end

        context "accessing other's tickets ticket_response" do
          before :each do
            ticket = create :ticket
            ticket_response = create :ticket_response, ticket: ticket
            get :show, params: {ticket_id: ticket.id, id: ticket_response.id}
          end

          it "doesn't have access to resource" do
            expect(response).to have_http_status(:unauthorized)
          end
        end
      end
    end

  end

  describe "POST #create" do
    context "Unauthenticated" do
      context "creation of ticket ticket_response" do
        before :each do
          ticket = create :ticket
          ticket_response = build :ticket_response, ticket: ticket
          post :create, {
            params: {ticket_id: ticket.id, ticket_response: ticket_response.attributes}
          }
        end

        it "has no authorization header" do
          expect(@request.headers['Authorization']).to be_nil
        end

        it "fails to create a new ticket_response" do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context "Authenticated" do
      context "as Admin" do
        before :each do
          @user = create :admin
          login(@user)
        end

        context "creation of ticket ticket_response" do
          before :each do
            ticket = create :ticket
            ticket_response = build :ticket_response, ticket: ticket
            post :create, {
              params: {ticket_id: ticket.id, ticket_response: ticket_response.attributes}
            }
          end

          it "fails to create a new Ticket" do
            expect(response).to have_http_status(:created)
          end
        end
      end

      context "as Customer" do
        before :each do
          @user = create :customer
          login(@user)
        end

        context "creation of ticket ticket_response" do
          before :each do
            ticket = create :ticket, author_id: @user.id
            ticket_response = build :ticket_response, ticket: ticket
            post :create, {
              params: {ticket_id: ticket.id, ticket_response: ticket_response.attributes}
            }
          end

          it "successfully creates a new Ticket" do
            expect(response).to have_http_status(:created)
          end
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "Unauthenticated" do
      context "deletion of Ticket" do
        before :each do
          ticket = create :ticket
          ticket_response = create :ticket_response, ticket: ticket

          delete :destroy, {params: {ticket_id: ticket.id, id: ticket_response.id}}
        end

        it "has no authorization header" do
          expect(@request.headers['Authorization']).to be_nil
        end

        it "fails to delete a Ticket" do
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context "deletion of non-existing Ticket" do
        before :each do
          @ticket = create :ticket
          @ticket_response = create :ticket_response, ticket: @ticket
        end

        it "has no authorization header" do
          expect(@request.headers['Authorization']).to be_nil
        end

        it "fails to delete a non-existing ticket ticket_response_id" do
          delete :destroy, {params: {ticket_id: @ticket.id, id: -1}}
          expect(response).to have_http_status(:not_found)
        end

        it "fails to delete a non-existing ticket_id ticket_response" do
          delete :destroy, {params: {ticket_id: -1, id: @ticket_response.id}}
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context "Authenticated" do
      context "as Admin" do
        before :each do
          @user = create :admin
          login(@user)
        end

        context "deletion of non-existing ticket ticket_response" do
          before :each do
            delete :destroy, {params: {ticket_id: -1, id: -1}}
          end

          it "fails to delete a ticket ticket_response" do
            expect(response).to have_http_status(:not_found)
          end
        end

        context "deletion of ticket ticket_response" do
          before :each do
            ticket = create :ticket
            ticket_response = create :ticket_response, ticket: ticket

            delete :destroy, {params: {ticket_id: ticket.id, id: ticket_response.id}}
          end

          it "successfully deletes a ticket ticket_response" do
            expect(response).to have_http_status(:success)
          end
        end
      end

      context "as SupportAgent" do
        before :each do
          @user = create :support_agent
          login(@user)
        end

        context "deletion of non-existing ticket ticket_response" do
          before :each do
            ticket = create :ticket
            ticket_response = create :ticket_response, ticket: ticket
            delete :destroy, {params: {ticket_id: ticket.id, id: -1}}
          end

          it "fails to delete a ticket ticket_response" do
            expect(response).to have_http_status(:not_found)
          end
        end

        context "deletion of ticket ticket_response" do
          before :each do
            ticket = create :ticket
            ticket_response = create :ticket_response, ticket: ticket

            delete :destroy, {params: {ticket_id: ticket.id, id: ticket_response.id}}
          end

          it "fails to delete a ticket ticket_response" do
            expect(response).to have_http_status(:unauthorized)
          end
        end
      end

      context "as Customer" do
        before :each do
          @user = create :customer
          login(@user)
        end

        context "deletion of non-existing ticket ticket_response" do
          before :each do
            delete :destroy, {params: {ticket_id: -1, id: -1}}
          end

          it "fails to delete a ticket ticket_response" do
            expect(response).to have_http_status(:not_found)
          end
        end

        context "deletion of other's ticket ticket_response" do
          before :each do
            ticket = create :ticket
            ticket_response = create :ticket_response, ticket: ticket

            delete :destroy, {params: {ticket_id: ticket.id, id: ticket_response.id}}
          end

          it "fails to delete a ticket ticket_response" do
            expect(response).to have_http_status(:unauthorized)
          end
        end

        context "deletion of own ticket ticket_response" do
          before :each do
            ticket = create :ticket, author: @user
            ticket_response = create :ticket_response, ticket: ticket

            delete :destroy, {params: {ticket_id: ticket.id, id: ticket_response.id}}
          end

          it "fails to delete its own ticket ticket_response" do
            expect(response).to have_http_status(:unauthorized)
          end
        end
      end
    end
  end
end
