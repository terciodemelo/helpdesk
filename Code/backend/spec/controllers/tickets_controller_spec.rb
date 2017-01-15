require 'rails_helper'

def login(user)
  token = JsonWebToken.encode({user_id: user.id})
  @request.headers['Authorization'] = "Bearer #{token}"
end

RSpec.describe TicketsController, type: :controller do

  describe "GET #index" do
    context "Unauthenticated" do
      before :each do
        create_list :ticket, 9

        get :index
      end

      it "doesn't have access to resource" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "Authenticated" do
      context "as Admin" do
        before :each do
          login(create :admin)

          create_list :ticket, 9

          get :index
        end

        it "has access to resource" do
          expect(response).to have_http_status(:success)
        end

        it "fetches nine tickets" do
          expect(JSON.parse(response.body).size).to eq(9)
        end
      end

      context "as SupportAgent" do
        before :each do
          login(create :support_agent)

          create_list :ticket, 9

          get :index
        end

        it "has access to resource" do
          expect(response).to have_http_status(:success)
        end

        it "fetches nine tickets" do
          expect(JSON.parse(response.body).size).to eq(9)
        end
      end

      context "as Customer" do
        before :each do
          @user = create :customer
          login(@user)
        end

        context "accessing other's tickets" do
          before :each do
            create_list :ticket, 9
            get :index
          end

          it "has access to resource" do
            expect(response).to have_http_status(:success)
          end

          it "fetches no ticket" do
            expect(JSON.parse(response.body).size).to eq(0)
          end
        end

        context "accessing their own tickets" do
          before :each do
            create_list :ticket, 9, author: @user
            get :index
          end
          it "has access to resource" do
            expect(response).to have_http_status(:success)
          end

          it "fetches nine tickets" do
            expect(JSON.parse(response.body).size).to eq(9)
          end
        end
      end
    end
  end

  describe "GET #show" do
    context "Unauthenticated" do
      before :each do
        @tickets = create_list :ticket, 5
      end

      it "cannot fetch an existing ticket" do
        get :show, params: {id: @tickets.sample.id}
        expect(response).to have_http_status(:unauthorized)
      end

      it "cannot fetch an non-existing ticket" do
        get :show, params: {id: -1}
        expect(response).to have_http_status(:not_found)
      end
    end

    context "Authenticated" do
      context "as Admin" do
        before :each do
          login(create :admin)
        end

        context "existing ticket" do
          before :each do
            tickets = create_list :ticket, 5
            get :show, params: {id: tickets.sample.id}
          end

          it "fetchs an existing ticket successfully" do
            expect(response).to have_http_status(:success)
          end

          it "the response must be a json" do
            expect(response.content_type).to eq('application/json')
          end

          it "the response must contain the author_id" do
            expect(JSON.parse(response.body)['author_id']).to be_a(Fixnum)
          end

          it "the response must contain the title" do
            expect(JSON.parse(response.body)['title']).to be_a(String)
          end

          it "the response must contain a body" do
            expect(JSON.parse(response.body)['body']).to be_a(String)
          end

          it "the response must contain a body" do
            expect(JSON.parse(response.body)['status']).to be_a(String)
          end
        end

        context "non-existing ticket" do
          before :each do
            tickets = create_list :ticket, 5
            get :show, params: {id: -1}
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

        context "existing ticket" do
          before :each do
            tickets = create_list :ticket, 5
            get :show, params: {id: tickets.sample.id}
          end

          it "fetchs an existing ticket successfully" do
            expect(response).to have_http_status(:success)
          end

          it "the response must be a json" do
            expect(response.content_type).to eq('application/json')
          end

          it "the response must contain the author_id" do
            expect(JSON.parse(response.body)['author_id']).to be_a(Fixnum)
          end

          it "the response must contain the title" do
            expect(JSON.parse(response.body)['title']).to be_a(String)
          end

          it "the response must contain a body" do
            expect(JSON.parse(response.body)['body']).to be_a(String)
          end

          it "the response must contain a body" do
            expect(JSON.parse(response.body)['status']).to be_a(String)
          end
        end

        context "non-existing ticket" do
          before :each do
            tickets = create_list :ticket, 5
            get :show, params: {id: -1}
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

        context "non-existing ticket" do
          before :each do
            tickets = create_list :ticket, 5
            get :show, params: {id: -1}
          end

          it "cannot fetch non-existing ticket successfully" do
            expect(response).to have_http_status(:not_found)
          end
        end

        context "accessing their own tickets" do
          before :each do
            ticket = create :ticket, author: @user
            get :show, params: {id: ticket.id}
          end

          it "fetchs an existing ticket successfully" do
            expect(response).to have_http_status(:success)
          end

          it "the response must be a json" do
            expect(response.content_type).to eq('application/json')
          end

          it "the response must contain the author_id" do
            expect(JSON.parse(response.body)['author_id']).to be_a(Fixnum)
          end

          it "the response must contain the title" do
            expect(JSON.parse(response.body)['title']).to be_a(String)
          end

          it "the response must contain a body" do
            expect(JSON.parse(response.body)['body']).to be_a(String)
          end

          it "the response must contain a body" do
            expect(JSON.parse(response.body)['status']).to be_a(String)
          end
        end

        context "accessing other's tickets" do
          before :each do
            tickets = create_list :ticket, 5
            get :show, params: {id: tickets.sample.id}
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
      context "creation of Ticket" do
        before :each do
          post :create, {params: {ticket: build(:ticket, author: nil).attributes}}
        end

        it "has no authorization header" do
          expect(@request.headers['Authorization']).to be_nil
        end

        it "fails to create a new Ticket" do
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

        context "creation of Ticket" do
          before :each do
            post :create, {
              params: { ticket: build(:ticket, author: nil).attributes }
            }
          end

          it "fails to create a new Ticket" do
            expect(response).to have_http_status(:unauthorized)
          end
        end
      end

      context "as Customer" do
        before :each do
          @user = create :customer
          login(@user)
        end

        context "creation of Ticket" do
          before :each do
            post :create, {
              params: { ticket: build(:ticket, author: nil).attributes }
            }
          end

          it "successfully creates a new Ticket" do
            expect(response).to have_http_status(:success)
          end
        end
      end
    end
  end

  describe "PUT #update" do
    context "Unauthenticated" do
      context "update of existing Ticket" do
        before :each do
          ticket = create :ticket, status: "OPEN"
          ticket.status = "CLOSED"

          put :update, {params: {id: ticket.id, ticket: ticket.attributes}}
        end

        it "has no authorization header" do
          expect(@request.headers['Authorization']).to be_nil
        end

        it "fails to update a Ticket" do
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context "update of non-existing Ticket" do
        before :each do
          ticket = create :ticket, status: "OPEN"
          ticket.status = "CLOSED"

          put :update, {params: {id: -1, ticket: ticket.attributes}}
        end

        it "has no authorization header" do
          expect(@request.headers['Authorization']).to be_nil
        end

        it "fails to update a Ticket" do
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

        context "update of non-existing Ticket" do
          before :each do
            ticket = create :ticket, status: "OPEN"
            ticket.status = "CLOSED"

            put :update, {params: {id: -1, ticket: ticket.attributes}}
          end

          it "fails to update a Ticket" do
            expect(response).to have_http_status(:not_found)
          end
        end

        context "update of Ticket" do
          before :each do
            ticket = create :ticket, status: "OPEN"
            ticket.status = "CLOSED"

            put :update, {params: {id: ticket.id, ticket: ticket.attributes}}
          end

          it "successfully updates a Ticket" do
            expect(response).to have_http_status(:success)
          end
        end
      end

      context "as SupportAgent" do
        before :each do
          @user = create :support_agent
          login(@user)
        end

        context "update of non-existing Ticket" do
          before :each do
            ticket = create :ticket, status: "OPEN"
            ticket.status = "CLOSED"

            put :update, {params: {id: -1, ticket: ticket.attributes}}
          end

          it "fails to update a Ticket" do
            expect(response).to have_http_status(:not_found)
          end
        end

        context "update of Ticket" do
          before :each do
            ticket = create :ticket, status: "OPEN"
            ticket.status = "CLOSED"

            put :update, {params: {id: ticket.id, ticket: ticket.attributes}}
          end

          it "successfully updates a Ticket" do
            expect(response).to have_http_status(:success)
          end
        end
      end

      context "as Customer" do
        before :each do
          @user = create :customer
          login(@user)
        end

        context "update of non-existing Ticket" do
          before :each do
            ticket = create :ticket, status: "OPEN"
            ticket.status = "CLOSED"

            put :update, {params: {id: -1, ticket: ticket.attributes}}
          end

          it "fails to update a Ticket" do
            expect(response).to have_http_status(:not_found)
          end
        end

        context "update of other's Ticket" do
          before :each do
            ticket = create :ticket, status: "OPEN"
            ticket.status = "CLOSED"

            put :update, {params: {id: ticket.id, ticket: ticket.attributes}}
          end

          it "fails to update a Ticket" do
            expect(response).to have_http_status(:unauthorized)
          end
        end

        context "update of own Ticket" do
          before :each do
            ticket = create :ticket, status: "OPEN", author: @user
            ticket.status = "CLOSED"

            put :update, {params: {id: ticket.id, ticket: ticket.attributes}}
          end

          it "successfully updates a Ticket" do
            expect(response).to have_http_status(:success)
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

          delete :destroy, {params: {id: ticket.id}}
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
          delete :destroy, {params: {id: -1}}
        end

        it "has no authorization header" do
          expect(@request.headers['Authorization']).to be_nil
        end

        it "fails to delete a Ticket" do
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

        context "deletion of non-existing Ticket" do
          before :each do
            delete :destroy, {params: {id: -1}}
          end

          it "fails to delete a Ticket" do
            expect(response).to have_http_status(:not_found)
          end
        end

        context "deletion of Ticket" do
          before :each do
            ticket = create :ticket

            delete :destroy, {params: {id: ticket.id}}
          end

          it "successfully deletes a Ticket" do
            expect(response).to have_http_status(:success)
          end
        end
      end

      context "as SupportAgent" do
        before :each do
          @user = create :support_agent
          login(@user)
        end

        context "deletion of non-existing Ticket" do
          before :each do
            delete :destroy, {params: {id: -1}}
          end

          it "fails to delete a Ticket" do
            expect(response).to have_http_status(:not_found)
          end
        end

        context "deletion of Ticket" do
          before :each do
            ticket = create :ticket

            delete :destroy, {params: {id: ticket.id}}
          end

          it "fails to delete a Ticket" do
            expect(response).to have_http_status(:unauthorized)
          end
        end
      end

      context "as Customer" do
        before :each do
          @user = create :customer
          login(@user)
        end

        context "deletion of non-existing Ticket" do
          before :each do
            delete :destroy, {params: {id: -1}}
          end

          it "fails to delete a Ticket" do
            expect(response).to have_http_status(:not_found)
          end
        end

        context "deletion of other's Ticket" do
          before :each do
            ticket = create :ticket

            delete :destroy, {params: {id: ticket.id}}
          end

          it "fails to delete a Ticket" do
            expect(response).to have_http_status(:unauthorized)
          end
        end

        context "deletion of own Ticket" do
          before :each do
            ticket = create :ticket, author: @user

            delete :destroy, {params: {id: ticket.id}}
          end

          it "fails to delete its own Ticket" do
            expect(response).to have_http_status(:unauthorized)
          end
        end
      end
    end
  end
end
