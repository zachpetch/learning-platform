class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :subscriptions, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :terms, through: :subscriptions
  has_many :course_offerings, through: :payments
  has_many :courses, through: :course_offerings

  validates :email_address, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  def name
    "#{first_name} #{last_name}"
  end

  def initials
    "#{first_name[0]}#{last_name[0]}"
  end

  def email
    "#{email_address}"
  end

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
