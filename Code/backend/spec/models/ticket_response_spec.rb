require 'rails_helper'

RSpec.describe TicketResponse, type: :model do
  describe "Model validity" do
    it "is invalid if has nil content" do
      expect(build :invalid_nil_ticket_response).to_not be_valid(TicketResponse)
    end

    it "is invalid if has empty content" do
      expect(build :invalid_empty_ticket_response).to_not be_valid(TicketResponse)
    end
  end
end
