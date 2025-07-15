class CourseOffering < ApplicationRecord
  belongs_to :course
  belongs_to :term

  has_many :payments, dependent: :destroy

  validates :course_id, uniqueness: { scope: :term_id }

  scope :available, -> { where(available: true) }
  scope :current, -> { joins(:term).merge(Term.current) }
  scope :upcoming, -> { joins(:term).merge(Term.upcoming) }

  def display_name
    "#{course.display_name} - #{term.name}"
  end
end
