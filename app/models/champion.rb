# app/models/champion.rb
class Champion < ApplicationRecord
  has_many :match_participants
  has_many :champion_masteries, dependent: :destroy

  validates :name, presence: true
  validates :riot_id, presence: true, uniqueness: true
  validates :riot_key, presence: true, uniqueness: true
  validates :icon_url, presence: true
end
