class Customer < User
  has_many :tickets

  def self.model_name
    User.model_name
  end
end
