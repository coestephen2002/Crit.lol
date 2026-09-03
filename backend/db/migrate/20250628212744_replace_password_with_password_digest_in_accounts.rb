class ReplacePasswordWithPasswordDigestInAccounts < ActiveRecord::Migration[7.0]
  def change
    remove_column :accounts, :password, :string
    remove_column :accounts, :salt, :string
    add_column :accounts, :password_digest, :string, null: false
  end
end