class Summoner < ApplicationRecord
  has_many :ranks, dependent: :destroy
  has_many :match_participants
  has_many :matches, through: :match_participants
  has_many :champion_masteries, dependent: :destroy
  
  validates :puuid, presence: true, uniqueness: true
  validates :name, uniqueness: { scope: [:tag, :region], message: "and tag already exist in this region" }

  def top_masteries(limit = 3)
    if champion_masteries.exists?
      champion_masteries.order(points: :desc).limit(limit)
    else
      fetch_and_store_masteries
      champion_masteries.order(points: :desc).limit(3)
    end
  end

  private

  def fetch_and_store_masteries
    result = Riot::RiotApiService.new(
      region: region,
      account_region: RiotRegionConcern::routing_region_for(region),
      path: "champion-mastery/v4/champion-masteries/by-puuid/#{puuid}",
    ).run!

    result.each do |mastery_data|
      champion_masteries.create!(
        champion_id: Champion.find_by(riot_key: mastery_data[:championId]).id,
        level: mastery_data[:championLevel],
        points: mastery_data[:championPoints],
        last_played: Time.at(mastery_data[:lastPlayTime] / 1000)
      )
    end
  rescue StandardError => e
    Rails.logger.error "Failed to fetch champion masteries: #{e.message}"
  end
end
