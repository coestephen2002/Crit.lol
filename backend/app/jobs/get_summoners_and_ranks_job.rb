class GetSummonersAndRanksJob
  include Sidekiq::Job
  include RiotRegionConcern
  sidekiq_options queue: :default, retry: 0

  def perform
    Rank.queue_types.each_value do |queue_type| 
      REGION_MAP.each do |small_region, big_region|
        Rank.tiers.each_value do |tier|
          Rank.divisions.each_value do |division|
              
            league_data = Riot::RiotApiService.new(
              region: small_region, #small region
              path: "league-exp/v4/entries/#{queue_type}/#{tier}/#{division}"
            ).run!

            league_data.first(1).each do |league_dto|
              puuid = league_dto[:puuid]
              
              summoner_data = Riot::RiotApiService.new(
                region: small_region, #small region
                path: "summoner/v4/summoners/by-puuid/#{puuid}"
              ).run!

              account_data = Riot::RiotApiService.new(
                account_region: big_region,
                path: "account/v1/accounts/by-puuid/#{puuid}"
              ).run!

              summoner = Summoner.find_or_create_by(puuid: puuid)
              summoner.update(
                name: account_data[:gameName],
                tag: account_data[:tagLine],
                summoner_level: summoner_data[:summonerLevel],
                profile_icon_id: summoner_data[:profileIconId],
                revision_date: summoner_data[:revisionDate],
                region: small_region
              )

              rank = summoner.ranks.find_or_create_by(queue_type: league_dto[:queueType])
              rank.update(
                tier: league_dto[:tier],
                division: league_dto[:rank],
                league_points: league_dto[:leaguePoints],
                wins: league_dto[:wins],
                losses: league_dto[:losses]
              )
            end
          end
        end
      end
    end
  end
end