class Rank::RankIndexService < ApplicationService

  private
  
  def setup
    super
    @summoner_id = @params[:summoner_id]
  end

  def execute
    ranks = RiotRankConcern::fetch_or_create_ranks(summoner_id: @summoner_id)

    @result = ranks.map do |rank|
      {
        summoner_id: rank.summoner_id,
        tier: rank.tier,
        division: rank.division,
        league_points: rank.league_points,
        queue_type: rank.queue_type,
        wins: rank.wins,
        losses: rank.losses
      }
    end
  end
end