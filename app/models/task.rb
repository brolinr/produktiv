# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :list, polymorphic: true
  belongs_to :project_user

  has_many :assignees, dependent: :destroy
  has_many :messages, dependent: :destroy, as: :room

  validates :title, presence: true
end
