class Bid < ApplicationRecord
  include ActionView::RecordIdentifier
  belongs_to :user
  belongs_to :batch
  validates :user_id, :batch_id, :amount, presence: true
  after_create_commit -> { broadcast_append_to "batch"}

end
