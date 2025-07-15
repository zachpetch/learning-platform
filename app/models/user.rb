class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :subscriptions, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :terms, through: :subscriptions

  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def initials
    "#{first_name[0]}#{last_name[0]}"
  end

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
