class Project < ApplicationRecord
  belongs_to :user, dependent: :destroy

  validates :title, :description, presence: true

  has_many :project_users, dependent: :destroy
end
