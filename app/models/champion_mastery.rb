class ChampionMastery < ApplicationRecord
  belongs_to :summoner
  belongs_to :champion

  validates :level, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :summoner_id, uniqueness: { scope: :champion_id, message: 'already has a mastery record for this champion' }

  scope :by_points, -> { order(points: :desc) }
  scope :recently_played, -> { where.not(last_played: nil).order(last_played: :desc) }
  scope :for_champion, ->(champion_id) { where(champion_id: champion_id) }

  def recently_played?
    last_played.present? && last_played > 7.days.ago
  end
end