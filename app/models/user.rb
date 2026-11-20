class User < ApplicationRecord
  has_many :photo_posts, dependent: :destroy
  has_many :point_transactions, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: %w[tourist admin] }
  validates :current_points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end