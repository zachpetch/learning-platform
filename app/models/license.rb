class License < ApplicationRecord
  has_many :subscriptions, dependent: :destroy

  validates :code, presence: true, uniqueness: true
  validates :term_count, presence: true, numericality: { greater_than: 0 }
end
