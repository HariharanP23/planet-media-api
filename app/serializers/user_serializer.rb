class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :status, :phone, :created_at
end
