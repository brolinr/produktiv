# frozen_string_literal: true

class MessageSerializer
  include JSONAPI::Serializer
  attributes :content, :title, :draft
  belongs_to :project_user, serializer: ProjectUserSerializer
  belongs_to :room, serializer: Proc.new { |record, params|
    case record
    when MessageBoard
      MessageBoardSerializer
    end
  }
end
