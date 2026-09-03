class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts, id: :uuid do |t|
      t.string :username, null: false
      t.string :password, null: false
      t.string :salt, null: false
      t.string :status, null: false, default: 'active'

      t.timestamps
    end
    add_index :accounts, :username, unique: true
  end
end
