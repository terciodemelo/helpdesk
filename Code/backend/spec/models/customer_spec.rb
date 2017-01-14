require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe "Model validity" do
    valid_users = {
      customer: "Customer with all attributes set"
    }

    invalid_users = {
      invalid_wrong_type_customer: "wrong type",
      invalid_empty_name_customer: "empty string name",
      invalid_nil_name_customer: "nil name",
      invalid_empty_email_customer: "empty string email",
      invalid_nil_email_customer: "nil email",
      invalid_empty_password_customer: "empty string password",
      invalid_nil_password_customer: "nil password"
    }

    valid_users.each do |valid_user, description|
      it "#{description} user is valid" do
        expect(build valid_user).to be_valid(Customer)
      end
    end

    invalid_users.each do |invalid_user, description|
      it "#{description} user is invalid Customer" do
        expect(build invalid_user).to_not be_valid(Customer)
      end
    end
  end
end
