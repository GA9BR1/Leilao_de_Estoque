class CreateDoubts < ActiveRecord::Migration[7.0]
  def change
    create_table :doubts do |t|
      t.string :content
      t.references :user, null: false, foreign_key: true
      t.references :batch, null: false, foreign_key: true
      t.boolean :visible, default: true

      t.timestamps
    end
  end
end
