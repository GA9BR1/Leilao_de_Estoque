class AddBlockedCpfToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :blocked_cpf, :boolean, default: false
  end
end
