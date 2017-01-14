class Ticket < ApplicationRecord
  belongs_to :author, :foreign_key => 'author_id', class_name: "User"

  validates :title, :body, :status, :author, presence: true
  validates :status, inclusion: { in: %w(OPEN CLOSED) }
end
