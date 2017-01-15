require "rails_helper"

RSpec.describe TicketsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/api/tickets").to route_to("tickets#index")
    end

    it "routes to #show" do
      expect(:get => "/api/tickets/1").to route_to("tickets#show", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/api/tickets").to route_to("tickets#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/api/tickets/1").to route_to("tickets#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/api/tickets/1").to route_to("tickets#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/api/tickets/1").to route_to("tickets#destroy", :id => "1")
    end

  end
end
