module RiotMatchConcern
  extend ActiveSupport::Concern
  include RiotGameConstantsConcern
  include RiotRegionConcern
  include RiotSummonerConcern

  def self.fetch_or_create_matches(summoner_id:)
    summoner = Summoner.find_by(id: summoner_id)
    raise ActiveRecord::RecordNotFound, "Summoner not found" unless summoner

    matches = summoner.matches
    matches = create_matches_from_riot(summoner: summoner) if matches.empty?
    matches
  end

  private 

  def self.create_matches_from_riot(summoner:)
    match_region = RiotRegionConcern::MATCH_REGION_MAP[summoner.region]
    
    matches = Riot::RiotApiService.new(
      match_region: match_region,
      path: "match/v5/matches/by-puuid/#{summoner.puuid}/ids"
    ).run!

    matches.first(20).each do |riot_match_id|
      
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
        m.map = RiotGameConstantsConcern::map_name(info[:mapId])
        m.winning_team_id = winning_team_id(info[:teams])
      end
      
      participants = info[:participants]
      participants.each do |participant_data|
        summoner_record = Summoner.find_by(puuid: participant_data[:puuid])
        unless summoner_record
          begin
            summoner_record = RiotSummonerConcern::create_summoner_from_riot(
              name: participant_data[:riotIdGameName],
              tag: participant_data[:riotIdTagline],
              region: match.region
            )
          rescue StandardError => e
            Rails.logger.error("Failed to create summoner for puuid #{participant_data[:puuid]}: #{e.message}")
            next
          end
        end

        champion = Champion.find_by(riot_key: participant_data[:championId])

        match.match_participants.find_or_create_by!(summoner_id: summoner_record.id) do |mp|
          mp.champion_id = champion.id
          mp.champion_level = participant_data[:champLevel]
          mp.team_id = participant_data[:teamId]
          mp.lane = participant_data[:lane]
          mp.role = participant_data[:role]
          mp.win = participant_data[:win]
          mp.kills = participant_data[:kills]
          mp.deaths = participant_data[:deaths]
          mp.assists = participant_data[:assists]
          mp.damage_to_champions = participant_data[:totalDamageDealtToChampions]
          mp.gold_earned = participant_data[:goldEarned]
          mp.creep_score = participant_data[:totalMinionsKilled] + (participant_data[:neutralMinionsKilled] || 0)
          mp.vision_score = participant_data[:visionScore]
          mp.double_kills = participant_data[:doubleKills]
          mp.triple_kills = participant_data[:tripleKills]
          mp.quadra_kills = participant_data[:quadraKills]
          mp.penta_kills = participant_data[:pentaKills]
        end
      end
    end

    summoner.matches
  end

  def self.game_duration_seconds(info)
    if info[:gameEndTimestamp] && info[:gameStartTimestamp]
      ((info[:gameEndTimestamp].to_i - info[:gameStartTimestamp].to_i) / 1000.0)
    elsif info[:gameEndTimestamp]
      info[:gameDuration].to_i
    else
      info[:gameDuration].to_i / 1000
    end
  end

  def self.winning_team_id(teams)
    winner = teams.find { |t| t[:win] == true }
    winner&.dig(:teamId) # => 100 or 200
  end
end