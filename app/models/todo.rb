# frozen_string_literal: true

class Todo < ApplicationRecord
  belongs_to :project
  has_many :todo_lists, dependent: :destroy
end
