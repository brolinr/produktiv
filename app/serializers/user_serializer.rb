class UserSerializer
  include JSONAPI::Serializer
  attributes :name, :username, :email
end
