class CreateRanks < ActiveRecord::Migration[7.1]
  def change
    create_table :ranks, id: :uuid do |t|
      t.references :summoner, null: false, foreign_key: true, type: :uuid
      t.string :queue_type, null: false, default: "RANKED_SOLO_5x5"
      t.string :tier, null: false, default: "IRON"
      t.string :division, null: false, default: "I"
      t.integer :league_points
      t.integer :wins
      t.integer :losses
      t.timestamps
    end

    add_index :ranks, [:summoner_id, :queue_type], unique: true,
      name: "idx_unique_ranks_on_summoner_and_queue"
    add_check_constraint :ranks,
      "queue_type IN ('RANKED_SOLO_5x5', 'RANKED_FLEX_SR')",
      name: "queue_type_check"
    add_check_constraint :ranks,
      "tier IN ('IRON', 'BRONZE', 'SILVER', 'GOLD', 'PLATINUM', 'EMERALD', 
                'DIAMOND', 'MASTER', 'GRANDMASTER', 'CHALLENGER')",
      name: "tier_check"
    add_check_constraint :ranks,
      "division IN ('I', 'II', 'III', 'IV')",
      name: "rank_check"
  end
end
