class CreateChampionMasteries < ActiveRecord::Migration[7.1]
  def change
    create_table :champion_masteries, id: :uuid do |t|
      t.references :summoner, type: :uuid, null: false, foreign_key: true
      t.references :champion, type: :uuid, null: false, foreign_key: true
      t.integer :level, null: false, default: 0
      t.integer :points, null: false, default: 0
      t.datetime :last_played

      t.timestamps
    end

    add_index :champion_masteries, [:summoner_id, :points], order: { points: :desc }
    add_index :champion_masteries, [:summoner_id, :champion_id], unique: true
  end
end