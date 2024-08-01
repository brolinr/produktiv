# frozen_string_literal: true

class Chat < ApplicationRecord
  belongs_to :project

  has_many :chat_members, dependent: :destroy
  has_many :messages, dependent: :destroy, as: :room
  has_many :project_users, through: :chat_members
end
