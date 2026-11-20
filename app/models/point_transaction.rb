class PointTransaction < ApplicationRecord
  belongs_to :user

  validates :amount, numericality: { only_integer: true, other_than: 0 }
  validates :transaction_type, presence: true, inclusion: { in: %w[獲得 利用] }
end