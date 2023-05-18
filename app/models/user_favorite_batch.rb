class UserFavoriteBatch < ApplicationRecord
  belongs_to :user
  belongs_to :batch
end
