class License < ApplicationRecord
  has_many :subscriptions, dependent: :destroy

  validates :code, presence: true, uniqueness: true
end
