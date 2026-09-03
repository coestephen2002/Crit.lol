class MatchParticipant < ApplicationRecord
  belongs_to :match
  belongs_to :summoner
  belongs_to :champion
end