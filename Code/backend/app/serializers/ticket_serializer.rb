class TicketSerializer < ActiveModel::Serializer
  attributes Ticket.column_names
  attribute :author_name

  def author_name
    object.author.name
  end
end
