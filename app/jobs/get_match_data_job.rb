class GetMatchDataJob
  include Sidekiq::Job
  include RiotRegionConcern
  include RiotGameConstantsConcern
  sidekiq_options queue: :default, retry: 0

  def perform
    
    Summoner.find_each do |summoner|
      
      match_region = RiotRegionConcern::MATCH_REGION_MAP[summoner.region]
      #encoded_puuid = ERB::Util.url_encode(summoner.puuid)
      
      matches = Riot::RiotApiService.new(
        match_region: match_region,
        path: "match/v5/matches/by-puuid/#{summoner.puuid}/ids"
      ).run!

      matches.first(5).each do |riot_match_id|
        
        match_data = Riot::RiotApiService.new(
          match_region: match_region,
          path: "match/v5/matches/#{riot_match_id}"
        ).run!

        metadata = match_data[:metadata]
        info = match_data[:info]

        match = Match.find_or_create_by!(riot_match_id: metadata[:matchId]) do |m|
          m.region = info[:platformId]
          m.game_version = info[:gameVersion].split('.').first(2).join('.')
          m.game_mode = info[:gameMode]
          m.game_duration = game_duration_seconds(info)
          m.game_creation = info[:gameCreation]
          m.queue_id = info[:queueId]
          m.map = map_name(info[:mapId])
          m.winning_team_id = winning_team_id(info[:teams])
        end
        
        participants = info[:participants]
        data = participants.find { |p| p[:puuid] == summoner.puuid }

        champion = Champion.find_by(riot_key: data[:championId])

        match.match_participants.find_or_create_by!(summoner_id: summoner.id) do |mp|
          mp.champion_id = champion.id
          mp.champion_level = data[:champLevel]
          mp.team_id = data[:teamId]
          mp.lane = data[:lane]
          mp.role = data[:role]
          mp.win = data[:win]
          mp.kills = data[:kills]
          mp.deaths = data[:deaths]
          mp.assists = data[:assists]
          mp.damage_to_champions = data[:totalDamageDealtToChampions]
          mp.gold_earned = data[:goldEarned]
          mp.creep_score = data[:totalMinionsKilled] + data[:neutralMinionsKilled]
          mp.vision_score = data[:visionScore]
          mp.double_kills = data[:doubleKills]
          mp.triple_kills = data[:tripleKills]
          mp.quadra_kills = data[:quadraKills]
          mp.penta_kills = data[:pentaKills]
        end
      end
    end
  end

  def game_duration_seconds(info)
    if info[:gameEndTimestamp] && info[:gameStartTimestamp]
      ((info[:gameEndTimestamp].to_i - info[:gameStartTimestamp].to_i) / 1000.0)
    elsif info[:gameEndTimestamp]
      info[:gameDuration].to_i
    else
      info[:gameDuration].to_i / 1000
    end
  end

  def winning_team_id(teams)
    winner = teams.find { |t| t[:win] == true }
    (winner && (winner[:teamId])) # => 100 or 200
  end
end