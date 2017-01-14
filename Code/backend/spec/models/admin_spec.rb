require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe "Model validity" do
    valid_users = {
      admin: "Admin with all attributes set"
    }

    invalid_users = {
      invalid_wrong_type_admin: "wrong type",
      invalid_empty_name_admin: "empty string name",
      invalid_nil_name_admin: "nil name",
      invalid_empty_email_admin: "empty string email",
      invalid_nil_email_admin: "nil email",
      invalid_empty_password_admin: "empty string password",
      invalid_nil_password_admin: "nil password"
    }

    valid_users.each do |valid_user, description|
      it "#{description} user is valid" do
        expect(build valid_user).to be_valid(Admin)
      end
    end

    invalid_users.each do |invalid_user, description|
      it "#{description} user is invalid Admin" do
        expect(build invalid_user).to_not be_valid(Admin)
      end
    end
  end
end
