class TicketResponseSerializer < ActiveModel::Serializer
  attributes :id, :body
  has_one :ticket
  has_one :author
end
