class AddBlockedCpfIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :blocked_cpf, foreign_key: { to_table: :blocked_cpfs }
  end
end
