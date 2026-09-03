class CreateSummonersTable < ActiveRecord::Migration[7.1]
  def change
    create_table :summoners, id: :uuid do |t|
      t.string :puuid, null: false, index: { unique: true }
      t.string :name, null: false
      t.string :tag, null: false
      t.integer :summoner_level, null: false
      t.integer :profile_icon_id, null: false
      t.bigint :revision_date
      t.string :region, null: false
      t.timestamps
    end
  end
end
