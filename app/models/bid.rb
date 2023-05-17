class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :batch
  validates :user_id, :batch_id, :amount, presence: true
  after_create_commit :remove_no_bids_if_first_bid

  def remove_no_bids_if_first_bid
    if self.batch.bids.count == 1
      broadcast_remove_to "batch", target: 'no_bids'
      broadcast_remove_to "batch_admin", target: 'no_bids'
      broadcast_append_to "batch"
      broadcast_append_to "batch_admin"
    else
      broadcast_append_to "batch"
      broadcast_append_to "batch_admin"
    end
  end
end
