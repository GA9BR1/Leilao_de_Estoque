class AddAnsweredToDoubts < ActiveRecord::Migration[7.0]
  def change
    add_column :doubts, :answered, :boolean, default: false
  end
end
