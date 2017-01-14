require 'rails_helper'

RSpec.describe SupportAgent, type: :model do
    describe "Model validity" do
    valid_users = {
      support_agent: "SupportAgent with all attributes set"
    }

    invalid_users = {
      invalid_wrong_type_support_agent: "wrong type",
      invalid_empty_name_support_agent: "empty string name",
      invalid_nil_name_support_agent: "nil name",
      invalid_empty_email_support_agent: "empty string email",
      invalid_nil_email_support_agent: "nil email",
      invalid_empty_password_support_agent: "empty string password",
      invalid_nil_password_support_agent: "nil password"
    }

    valid_users.each do |valid_user, description|
      it "#{description} user is valid" do
        expect(build valid_user).to be_valid(SupportAgent)
      end
    end

    invalid_users.each do |invalid_user, description|
      it "#{description} user is invalid SupportAgent" do
        expect(build invalid_user).to_not be_valid(SupportAgent)
      end
    end
  end
end
