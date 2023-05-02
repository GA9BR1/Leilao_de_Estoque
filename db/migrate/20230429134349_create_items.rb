class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.integer :weight
      t.integer :width
      t.integer :height
      t.integer :depth
      t.references :item_category, null: false, foreign_key: true
      t.string :registration_code

      t.timestamps
    end
  end
end
