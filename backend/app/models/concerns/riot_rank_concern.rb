module RiotRankConcern
  extend ActiveSupport::Concern

  def self.fetch_or_create_ranks(summoner_id:)
    summoner = Summoner.find_by(id: summoner_id)
    raise ActiveRecord::RecordNotFound, "Summoner not found" unless summoner

    # not sure if we want to actually follow this create pattern or just get the ranks already in the db and have an update button or something.
    ranks = summoner.ranks
    ranks = create_ranks_from_riot(summoner: summoner) if ranks.empty?

    puts ranks
    return ranks
  end

  private

  def self.create_ranks_from_riot(summoner:)
    rank_data = Riot::RiotApiService.new(
      region: summoner.region.downcase,
      path: "league/v4/entries/by-puuid/#{summoner.puuid}"
    ).run!

    rank_data.each do |league_dto|
      summoner.ranks.find_or_create_by!(queue_type: league_dto[:queueType]) do |r|
        r.tier = league_dto[:tier]
        r.division = league_dto[:rank]
        r.league_points = league_dto[:leaguePoints]
        r.wins = league_dto[:wins]
        r.losses = league_dto[:losses]
      end
    end

    summoner.ranks
  end
end