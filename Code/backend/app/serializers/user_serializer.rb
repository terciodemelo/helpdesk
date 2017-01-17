class UserSerializer < ActiveModel::Serializer
  attributes User.column_names.select { |c| c != "password" }
  attribute :closed_tickets
  attribute :open_tickets

  def closed_tickets
    object.tickets.where(status: 'CLOSED').count if object.is_a? Customer
  end

  def open_tickets
    object.tickets.where(status: 'OPEN').count if object.is_a? Customer
  end
end
