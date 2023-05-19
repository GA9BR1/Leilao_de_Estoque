class RemoveBlockedCpfFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :blocked_cpf, :boolean
  end
end
