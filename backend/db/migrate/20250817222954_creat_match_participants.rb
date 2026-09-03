class CreatMatchParticipants < ActiveRecord::Migration[7.1]
  def change
    create_table :match_participants, id: :uuid do |t|
      t.references :match, null: false, type: :uuid, foreign_key: true, index: true
      t.references :summoner, null: false, type: :uuid, foreign_key: true, index: true
      t.references :champion, null: false, type: :uuid, foreign_key: true, index: true

      t.integer :champion_level, null: false, default: 1
      t.integer :team_id, null: false
      t.string :lane, :role
      t.boolean :win, null: false, default: false

      t.integer :kills, :deaths, :assists, null: false, default: 0
      t.integer :damage_to_champions, :gold_earned, :creep_score, :vision_score, null: false, default: 0
      t.integer :double_kills, :triple_kills, :quadra_kills, :penta_kills, null: false, default: 0

      t.timestamps
    end

    add_index :match_participants, [:summoner_id, :match_id], unique: true
  end
end
