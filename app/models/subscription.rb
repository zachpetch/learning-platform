class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :term
  belongs_to :license, optional: true
  has_many :payments

  enum :status, [ :active, :expired, :cancelled ], default: :active

  validates :user_id, presence: true, uniqueness: { scope: :term_id }
  validates :status, presence: true
  validates :term_id, presence: true

  scope :current, -> { joins(:term).merge(Term.current) }
  scope :upcoming, -> { joins(:term).merge(Term.upcoming) }

  def licensed?
    license.present?
  end

  def display_name
    "#{term.school.short_name}: #{term.name}"
  end
end
