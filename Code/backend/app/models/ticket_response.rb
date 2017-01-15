class TicketResponse < ApplicationRecord
  belongs_to :ticket
  belongs_to :author, :foreign_key => 'author_id', class_name: "User"

  validates :body, presence: true
end
