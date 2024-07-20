class ProjectUserSerializer
  include JSONAPI::Serializer
  attributes :role, :invite_status, :user_id, :project_id
end
