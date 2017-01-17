class TicketSerializer < ActiveModel::Serializer
  attributes Ticket.column_names
  attribute :author_name
  attribute :responses_count
  has_many :ticket_responses

  def author_name
    object.author.name
  end

  def responses_count
    object.ticket_responses.count
  end
end
