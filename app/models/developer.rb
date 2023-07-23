class Developer < ApplicationRecord
  belongs_to :user
  has_one_attached :photo
  has_many :bookings, dependent: :destroy
  has_many :reviews, through: :bookings
  validates :first_name, :last_name, :description, :city, :price_per_day, presence: true
  validates :first_name, length: { minimum: 2 }
  validates :last_name, length: { minimum: 1 }
  validates :description, length: { minimum: 100, maximum: 1000 }
  geocoded_by :city
  after_validation :geocode, if: :will_save_change_to_city?

  include PgSearch::Model
  pg_search_scope :search_by_city_and_description,
    against: [ :city, :description ],
    using: {
      tsearch: { prefix: true }
    }
end
