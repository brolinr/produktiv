# frozen_string_literal: true

class TodoList < ApplicationRecord
  has_rich_text :description

  belongs_to :todo
  belongs_to :project_user

  has_many :todo_items, as: :list, dependent: :destroy

  validates :title, :description, presence: true
end
