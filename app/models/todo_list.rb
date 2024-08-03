# frozen_string_literal: true

class TodoList < ApplicationRecord
  has_rich_text :description

  belongs_to :todo

  validates :title, :description, presence: true
end
