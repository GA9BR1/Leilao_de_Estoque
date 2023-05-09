class AddEndStatusToBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :batches, :end_status, :integer, default: 0
  end
end
