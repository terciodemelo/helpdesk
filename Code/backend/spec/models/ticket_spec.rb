require 'rails_helper'

RSpec.describe Ticket, type: :model do
  describe "Model validity" do
    it "is is invalid if has nil title" do
      expect(build :invalid_nil_title_ticket).to_not be_valid(Ticket)
    end

    it "is is invalid if has empty title" do
      expect(build :invalid_empty_title_ticket).to_not be_valid(Ticket)
    end

    it "is is invalid if has nil body" do
      expect(build :invalid_nil_body_ticket).to_not be_valid(Ticket)
    end

    it "is is invalid if has empty body" do
      expect(build :invalid_empty_body_ticket).to_not be_valid(Ticket)
    end

    it "is is invalid if status is neither 'OPEN' or 'CLOSED'" do
      expect(build :invalid_wrong_status_ticket).to_not be_valid(Ticket)
    end
  end
end
