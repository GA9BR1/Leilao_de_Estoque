class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :batch
  validates :user_id, :batch_id, :amount, presence: true
end
