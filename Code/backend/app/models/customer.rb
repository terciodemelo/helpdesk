class Customer < User
  has_many :tickets, foreign_key: :author_id

  def self.model_name
    User.model_name
  end
end
