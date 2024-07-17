class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, :name, presence: true
  validates :username, uniqueness: true
  validate :password_confirmation_presence

  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end

  private
  def password_confirmation_presence
    if password.present? && password_confirmation.blank?
      errors.add(:password_confirmation, "can't be blank")
    end
  end

  def unconfirmed_email_update
    if self.respond_to?(:unconfirmed_email) && self.persisted?
      errors.add(:base, "Confirm your account first!")
    end
  end
end
