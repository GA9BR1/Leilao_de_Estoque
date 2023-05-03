class BatchItem < ApplicationRecord
  belongs_to :batch
  belongs_to :item
  validates :batch_id, :item_id, presence: true
end
