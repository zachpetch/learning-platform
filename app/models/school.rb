class School < ApplicationRecord
  has_many :terms, dependent: :destroy
  has_many :courses, dependent: :destroy

  validates :name, presence: true
  validates :short_name, presence: true

  scope :search, ->(query) {
    return all if query.blank?
    where("LOWER(name) LIKE :q OR LOWER(short_name) LIKE :q", q: "%#{query.downcase}%").order(:name)
  }
end
