# frozen_string_literal: true

class Chat < ApplicationRecord
  belongs_to :project

  has_many :chat_members, dependent: :destroy
end
