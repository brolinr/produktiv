# frozen_string_literal: true

class ProjectUser < ApplicationRecord
  enum :role, { member: 0, admin: 1 }
  enum :invite_status, { pending: 0, accepted: 1, rejected: 2 }

  belongs_to :user
  belongs_to :project

  has_many :messages, dependent: :destroy

  validates :user_id, uniqueness: { scope: :project_id, message: " already added" }
end
