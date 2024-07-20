class ProjectSerializer
  include JSONAPI::Serializer
  attributes :title, :description, :user_id, include_links: false
end
