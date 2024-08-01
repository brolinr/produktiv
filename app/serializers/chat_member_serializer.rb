# frozen_string_literal: true

class ChatMemberSerializer
  include JSONAPI::Serializer

  belongs_to :chat, serializer: ChatSerializer
  belongs_to :project_user, serializer: ProjectUserSerializer

  has_many :messages, serializer: MessageSerializer
end
