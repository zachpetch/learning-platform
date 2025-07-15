class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :term
  belongs_to :license, optional: true
  belongs_to :payment, optional: true

  enum status: { active: 0, expired: 1, cancelled: 2 }

  validates :user_id, uniqueness: { scope: :term_id }
  validates :status, presence: true

  validate :has_payment_or_license

  scope :current, -> { joins(:term).merge(Term.current) }
  scope :upcoming, -> { joins(:term).merge(Term.upcoming) }

  def paid?
    payment.present? && payment.completed?
  end

  def licensed?
    license.present?
  end

  private

  def has_payment_or_license
    if payment.blank? && license.blank?
      errors.add(:base, "Subscription must have either a payment or a license")
    elsif payment.present? && license.present?
      errors.add(:base, "Subscription cannot have both a payment and a license")
    end
  end
end
