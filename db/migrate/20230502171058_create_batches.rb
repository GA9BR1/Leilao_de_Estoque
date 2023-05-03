class CreateBatches < ActiveRecord::Migration[7.0]
  def change
    create_table :batches do |t|
      t.string :code
      t.date :start_date
      t.date :end_date
      t.decimal :minimum_bid_difference
      t.references :created_by, null: false, foreign_key: { to_table: :users }
      t.references :approved_by, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
