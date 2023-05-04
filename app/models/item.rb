class Item < ApplicationRecord
  belongs_to :item_category
  has_many :batch_items
  has_many :batches, through: :batch_items
  has_one_attached :image
  validates :name, :image, :description, :weight, :width, :height, :depth, :item_category_id, presence: true

  before_validation :generate_code, on: :create

  def dimensions
    "#{self.width}cm x #{self.height}cm x #{self.depth}cm"
  end

  private

  def generate_code
    self.registration_code = SecureRandom.alphanumeric(10).upcase
  end

  def code_and_name
    "#{code} - #{name}"
  end
end