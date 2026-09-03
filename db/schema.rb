# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_08_24_203630) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "username", null: false
    t.string "status", default: "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest", null: false
    t.index ["username"], name: "index_accounts_on_username", unique: true
  end

  create_table "champion_masteries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "summoner_id", null: false
    t.uuid "champion_id", null: false
    t.integer "level", default: 0, null: false
    t.integer "points", default: 0, null: false
    t.datetime "last_played"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["champion_id"], name: "index_champion_masteries_on_champion_id"
    t.index ["summoner_id", "champion_id"], name: "index_champion_masteries_on_summoner_id_and_champion_id", unique: true
    t.index ["summoner_id", "points"], name: "index_champion_masteries_on_summoner_id_and_points", order: { points: :desc }
    t.index ["summoner_id"], name: "index_champion_masteries_on_summoner_id"
  end

  create_table "champions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "title"
    t.string "icon_url", null: false
    t.string "riot_id", null: false
    t.integer "riot_key", null: false
    t.string "tags", default: [], null: false, array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_champions_on_name"
    t.index ["riot_id"], name: "index_champions_on_riot_id", unique: true
    t.index ["riot_key"], name: "index_champions_on_riot_key", unique: true
  end

  create_table "match_participants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "match_id", null: false
    t.uuid "summoner_id", null: false
    t.uuid "champion_id", null: false
    t.integer "champion_level", default: 1, null: false
    t.integer "team_id", null: false
    t.string "lane"
    t.string "role"
    t.boolean "win", default: false, null: false
    t.integer "kills", default: 0, null: false
    t.integer "deaths", default: 0, null: false
    t.integer "assists", default: 0, null: false
    t.integer "damage_to_champions", default: 0, null: false
    t.integer "gold_earned", default: 0, null: false
    t.integer "creep_score", default: 0, null: false
    t.integer "vision_score", default: 0, null: false
    t.integer "double_kills", default: 0, null: false
    t.integer "triple_kills", default: 0, null: false
    t.integer "quadra_kills", default: 0, null: false
    t.integer "penta_kills", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["champion_id"], name: "index_match_participants_on_champion_id"
    t.index ["match_id"], name: "index_match_participants_on_match_id"
    t.index ["summoner_id", "match_id"], name: "index_match_participants_on_summoner_id_and_match_id", unique: true
    t.index ["summoner_id"], name: "index_match_participants_on_summoner_id"
  end

  create_table "matches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "riot_match_id", null: false
    t.string "region", null: false
    t.string "game_version", null: false
    t.string "game_mode", null: false
    t.bigint "game_creation", null: false
    t.bigint "game_duration"
    t.integer "queue_id", null: false
    t.string "map", null: false
    t.integer "winning_team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["riot_match_id"], name: "index_matches_on_riot_match_id", unique: true
  end

  create_table "ranks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "summoner_id", null: false
    t.string "queue_type", default: "RANKED_SOLO_5x5", null: false
    t.string "tier", default: "IRON", null: false
    t.string "division", default: "I", null: false
    t.integer "league_points"
    t.integer "wins"
    t.integer "losses"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["summoner_id", "queue_type"], name: "idx_unique_ranks_on_summoner_and_queue", unique: true
    t.index ["summoner_id"], name: "index_ranks_on_summoner_id"
    t.check_constraint "division::text = ANY (ARRAY['I'::character varying, 'II'::character varying, 'III'::character varying, 'IV'::character varying]::text[])", name: "rank_check"
    t.check_constraint "queue_type::text = ANY (ARRAY['RANKED_SOLO_5x5'::character varying, 'RANKED_TFT'::character varying, 'RANKED_FLEX_SR'::character varying, 'RANKED_FLEX_TT'::character varying]::text[])", name: "queue_type_check"
    t.check_constraint "tier::text = ANY (ARRAY['IRON'::character varying, 'BRONZE'::character varying, 'SILVER'::character varying, 'GOLD'::character varying, 'PLATINUM'::character varying, 'EMERALD'::character varying, 'DIAMOND'::character varying, 'MASTER'::character varying, 'GRANDMASTER'::character varying, 'CHALLENGER'::character varying]::text[])", name: "tier_check"
  end

  create_table "summoners", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "puuid", null: false
    t.string "name", null: false
    t.string "tag", null: false
    t.integer "summoner_level", null: false
    t.integer "profile_icon_id", null: false
    t.bigint "revision_date"
    t.string "region", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["puuid"], name: "index_summoners_on_puuid", unique: true
  end

  add_foreign_key "champion_masteries", "champions"
  add_foreign_key "champion_masteries", "summoners"
  add_foreign_key "match_participants", "champions"
  add_foreign_key "match_participants", "matches"
  add_foreign_key "match_participants", "summoners"
  add_foreign_key "ranks", "summoners"
end
