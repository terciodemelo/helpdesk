class TicketSerializer < ActiveModel::Serializer
  attributes Ticket.column_names
  attribute :author_name
  has_many :ticket_responses

  def author_name
    object.author.name
  end
end
