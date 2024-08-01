# frozen_string_literal: true

class ChatMember < ApplicationRecord
  belongs_to :chat
  belongs_to :project_user

  has_many :messages, dependent: :destroy, as: :sender

  validates :project_user_id, uniqueness: { scope: :chat_id }
end
