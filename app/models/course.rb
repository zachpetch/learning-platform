class Course < ApplicationRecord
  belongs_to :school
  has_many :course_offerings, dependent: :destroy
  has_many :terms, through: :course_offerings
  has_many :payments, through: :course_offerings

  validates :subject, presence: true
  validates :number, presence: true, numericality: { greater_than: 0 }
  validates :number, uniqueness: { scope: [:school_id, :subject] }

  def course_code
    "#{shorthand} #{number}"
  end

  def display_name
    name.present? ? "#{course_code}: #{name}" : course_code
  end

  private

  def shorthand
    return "" if subject.blank?
    
    vowels = ['A', 'E', 'I', 'O', 'U']
    upper_case_subject = subject.upcase
    
    # Use the first 3 characters unless second or third character is a vowel, then use the first 4
    if upper_case_subject.length >= 2 && vowels.include?(upper_case_subject[1]) ||
       upper_case_subject.length >= 3 && vowels.include?(upper_case_subject[2])
      upper_case_subject[0, 4]
    else
      upper_case_subject[0, 3]
    end
  end
end
