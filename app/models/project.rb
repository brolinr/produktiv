# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :user, dependent: :destroy

  validates :title, :description, presence: true

  has_many :project_users, dependent: :destroy
  has_many :messages, through: :project_users
  has_many :chats, dependent: :destroy

  has_one :message_board, dependent: :destroy
  has_one :todo, dependent: :destroy
end
