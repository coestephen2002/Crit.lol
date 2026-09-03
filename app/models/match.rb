class Match < ApplicationRecord
  has_many :match_participants, dependent: :destroy

  validates :region, :game_version, :game_mode, :game_creation, :queue_id, :map, presence: true
end