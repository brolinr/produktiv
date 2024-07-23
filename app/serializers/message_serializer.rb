class MessageSerializer
  include JSONAPI::Serializer
  attributes :content, :title, :draft
  belongs_to :project_user, record_type: :project_user
  belongs_to :message_board, record_type: :message_board
end
