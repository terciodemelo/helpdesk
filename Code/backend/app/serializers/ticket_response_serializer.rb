class TicketResponseSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at
  attribute :author_name
  attribute :author_id

  def author_name
    object.author.name
  end

  def author_id
    object.author_id
  end
end
