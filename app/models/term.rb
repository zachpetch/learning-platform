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
  validates :sequence_num, uniqueness: { scope: [:school_id, :year] }

  validate :end_date_after_start_date

  scope :current, -> { where('start_date <= ? AND end_date >= ?', Date.current, Date.current) }
  scope :upcoming, -> { where('start_date > ?', Date.current) }
  scope :past, -> { where('end_date < ?', Date.current) }

  def current?
    Date.current.between?(start_date, end_date)
  end

  def upcoming?
    start_date > Date.current
  end

  def past?
    end_date < Date.current
  end

  private

  def end_date_after_start_date
    return unless start_date && end_date
    
    if end_date <= start_date
      errors.add(:end_date, "must be after start date")
    end
  end
end
