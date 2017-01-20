class Customer < User
  has_many :tickets, foreign_key: :author_id, dependent: :destroy

  def self.model_name
    User.model_name
  end
end
