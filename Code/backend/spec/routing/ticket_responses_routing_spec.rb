require "rails_helper"

RSpec.describe TicketResponsesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/api/tickets/1/ticket_responses").to route_to("ticket_responses#index", :ticket_id => "1")
    end

    it "routes to #show" do
      expect(:get => "/api/tickets/1/ticket_responses/1").to route_to("ticket_responses#show", :ticket_id => "1", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/api/tickets/1/ticket_responses").to route_to("ticket_responses#create", :ticket_id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/api/tickets/1/ticket_responses/1").to route_to("ticket_responses#destroy", :ticket_id => "1", :id => "1")
    end

  end
end
