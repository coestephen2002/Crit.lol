class Rank < ApplicationRecord
    belongs_to :summoner
    validates :queue_type, presence: true, uniqueness: { scope: :summoner_id }

    enum queue_type: {
      RANKED_SOLO_5x5: "RANKED_SOLO_5x5", RANKED_FLEX_SR: "RANKED_FLEX_SR"
    }
    
    enum tier: {
      IRON: "IRON", BRONZE: "BRONZE", SILVER: "SILVER", GOLD: "GOLD",
      PLATINUM: "PLATINUM", EMERALD: "EMERALD", DIAMOND: "DIAMOND",
      MASTER: "MASTER", GRANDMASTER: "GRANDMASTER", CHALLENGER: "CHALLENGER"
    }

    enum division: {
      I: "I", II: "II", III: "III", IV: "IV"
    }

    validates :queue_type, inclusion: { in: queue_types.keys }
    validates :tier, inclusion: { in: tiers.keys }
    validates :division, inclusion: { in: divisions.keys }

    validates :league_points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
    validates :wins, :losses, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
end