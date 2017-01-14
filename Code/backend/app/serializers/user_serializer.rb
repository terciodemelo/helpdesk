class UserSerializer < ActiveModel::Serializer
  attributes User.column_names.select { |c| c != "password" }
end
