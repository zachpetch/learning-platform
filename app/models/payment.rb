class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :subscription, optional: true
  belongs_to :course_offering, optional: true
  has_one :subscription_payment, class_name: "Subscription", foreign_key: "payment_id"

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :provider, presence: true
  validates :provider_transaction_id, presence: true, uniqueness: true

  validate :for_subscription_or_course

  scope :completed, -> { where.not(completed_at: nil) }
  scope :pending, -> { where(completed_at: nil) }
  scope :refunded, -> { where.not(refunded_at: nil) }

  def completed?
    completed_at.present?
  end

  def pending?
    completed_at.blank?
  end

  def refunded?
    refunded_at.present?
  end

  def dollar_amount
    amount / 100.0
  end

  def complete!
    update!(completed_at: Time.current)
  end

  def refund!
    update!(refunded_at: Time.current)
  end

  private

  def for_subscription_or_course
    if subscription.blank? && course_offering.blank?
      errors.add(:base, "Payment must be for either a subscription or a course offering")
    elsif subscription.present? && course_offering.present?
      errors.add(:base, "Payment cannot be for both a subscription and a course offering")
    end
  end
end
