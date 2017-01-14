require 'rails_helper'

RSpec.describe User, type: :model do
  context "model validity" do
    it 'is invalid if type is an empty string' do
      expect(build :invalid_empty_type_user).to_not be_valid(User)
    end

    it 'is invalid if type is nil string' do
      expect(build :invalid_nil_type_user).to_not be_valid(User)
    end

    it 'is invalid if type field is not Customer, SupportAgent or Admin' do
      expect(build :invalid_wrong_type_user).to_not be_valid(User)
    end
  end
end
