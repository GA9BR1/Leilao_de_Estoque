class AddColumnToBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :batches, :minimum_bid, :decimal
  end
end
