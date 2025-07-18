class Term < ApplicationRecord
  belongs_to :school

  has_many :course_offerings, dependent: :destroy
  has_many :courses, through: :course_offerings
  has_many :subscriptions, dependent: :destroy

  validates :name, presence: true
  validates :year, presence: true, numericality: { greater_than: 1900 }
  validates :sequence_num, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :name, uniqueness: { scope: :school_id }
  validates :sequence_num, uniqueness: { scope: [ :school_id, :year ] }

  validate :end_date_after_start_date

  scope :current, -> { where("start_date <= ? AND end_date >= ?", Date.current, Date.current) }
  scope :upcoming, -> { where("start_date > ?", Date.current) }
  scope :past, -> { where("end_date < ?", Date.current) }

  scope :search, ->(query) {
    base = joins(:school)
             .left_joins(:subscriptions)
             .left_joins(subscriptions: :license)
             .left_joins(subscriptions: :payments)
             .select(
               "terms.*",
               "COUNT(DISTINCT subscriptions.user_id) AS total_subscriptions_count",
               "COUNT(DISTINCT CASE WHEN payments.completed_at IS NOT NULL THEN payments.user_id END) AS paid_subscriptions_count",
               "COUNT(DISTINCT CASE WHEN subscriptions.license_id IS NOT NULL THEN subscriptions.user_id END) AS licensed_subscriptions_count"
             )
             .group("terms.id", "schools.id")
             .order(:id)

    return base if query.blank?

    q = "%#{query.downcase}%"
    base.where(
      "LOWER(terms.name) LIKE :q OR LOWER(schools.name) LIKE :q OR LOWER(schools.short_name) LIKE :q",
      q: q
    )
  }

  def current?
    Date.current.between?(start_date, end_date)
  end

  def upcoming?
    start_date > Date.current
  end

  def past?
    end_date < Date.current
  end

  def total_subscriptions_count
    self[:total_subscriptions_count] || subscriptions.count
  end

  def paid_subscriptions_count
    self[:paid_subscriptions_count] || subscriptions.joins(:payment).distinct.count(:user_id)
  end

  def licensed_subscriptions_count
    self[:licensed_subscriptions_count] || subscriptions.joins(:license).distinct.count(:user_id)
  end

  def subscription_for(user)
    subscriptions.find_by(user: user)
  end

  private

  def end_date_after_start_date
    return unless start_date && end_date

    if end_date <= start_date
      errors.add(:end_date, "must be after start date")
    end
  end
end
