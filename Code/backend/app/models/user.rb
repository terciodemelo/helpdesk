class User < ApplicationRecord

  validates :type, :name, :email, :password,  presence: true
  validates :type, inclusion: { in: %w(Customer SupportAgent Admin) }
end
