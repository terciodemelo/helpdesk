class TicketResponseSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at
  attribute :author_name
  has_one :author

  def author_name
    object.author.name
  end
end
