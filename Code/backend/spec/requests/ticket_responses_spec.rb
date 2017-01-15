require 'rails_helper'

RSpec.describe "TicketResponses", type: :request do
  describe "GET /ticket_responses" do
    it "works! (now write some real specs)" do
      get ticket_responses_path
      expect(response).to have_http_status(200)
    end
  end
end
