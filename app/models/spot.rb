class Spot < ApplicationRecord
  has_many :photo_posts, dependent: :destroy

  validates :name, presence: true
  validates :reward_points, numericality: { only_integer: true, greater_than: 0 }
end