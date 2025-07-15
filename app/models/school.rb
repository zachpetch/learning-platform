class School < ApplicationRecord
  has_many :terms, dependent: :destroy
  has_many :courses, dependent: :destroy

  validates :name, presence: true
end
