class CreateBatchItems < ActiveRecord::Migration[7.0]
  def change
    create_table :batch_items do |t|
      t.references :batch, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
