# frozen_string_literal: true

class Assignee < ApplicationRecord
  belongs_to :project_user
  belongs_to :task
end
