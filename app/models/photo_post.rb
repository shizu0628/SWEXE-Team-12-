class PhotoPost < ApplicationRecord
  belongs_to :user
  belongs_to :spot

  validates :image_url, presence: true
  validates :status, presence: true, inclusion: { in: %w[審査中 承認 却下] }
end