# frozen_string_literal: true

class MessageSerializer
  include JSONAPI::Serializer
  attributes :content, :title, :draft, :sender
end
