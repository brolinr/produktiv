# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, :name, presence: true
  validates :username, uniqueness: { case_insensitive: true }
  validate :password_confirmation_presence

  has_many :access_grants,
    class_name: "Doorkeeper::AccessGrant",
    foreign_key: :resource_owner_id,
    dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
    class_name: "Doorkeeper::AccessToken",
    foreign_key: :resource_owner_id,
    dependent: :delete_all # or :destroy if you need callbacks

  has_many :project_users,
    class_name: "::ProjectUser",
    foreign_key: :user_id,
    dependent: :destroy

  has_many :project_users, dependent: :destroy
  has_many :chat_members, through: :project_users
  has_many :projects, dependent: :destroy
  has_many :messages, through: :project_user
  has_many :chats, through: :projects

  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end

  private
  def password_confirmation_presence
    return unless password.present? && password_confirmation.blank?
      errors.add(:password_confirmation, "can't be blank")
  end

  def unconfirmed_email_update
    return unless self.respond_to?(:unconfirmed_email) && self.persisted?
      errors.add(:base, "Confirm your account first!")
  end
end
