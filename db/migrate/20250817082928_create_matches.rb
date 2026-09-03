class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches, id: :uuid do |t|
      t.string :riot_match_id, null: false, index: { unique: true }
      t.string :region, null: false
      t.string :game_version, null: false
      t.string :game_mode, null: false
      t.bigint :game_creation, null: false
      t.bigint :game_duration
      t.integer :queue_id, null: false
      t.string :map, null: false
      t.integer :winning_team_id
      t.timestamps
    end
  end
end
