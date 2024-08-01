# frozen_string_literal: true

class ChatSerializer
  include JSONAPI::Serializer

  belongs_to :project, serializer: ProjectSerializer

  has_many :messages, serializer: MessageSerializer
  has_many :chat_members, serializer: ChatMemberSerializer
end
