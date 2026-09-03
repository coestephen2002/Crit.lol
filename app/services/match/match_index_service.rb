class Match::MatchIndexService < ApplicationService

  private
  
  def setup
    super
    @summoner_id = @params[:summoner_id]
    @count = @params[:count] || 10
  end

  def execute
    matches = RiotMatchConcern::fetch_or_create_matches(summoner_id: @summoner_id)
      .includes(match_participants: [:champion, :summoner])
      .order(game_creation: :desc)
      .limit(@count)

    @result = matches.map do |match|
      {
        match_id: match.id,
        game_version: match.game_version,
        game_mode: match.game_mode,
        game_creation: match.game_creation,
        game_duration: match.game_duration,
        queue_type: RiotGameConstantsConcern::QUEUE_INFO.dig(match.queue_id, :description) || "Unknown Queue (#{match.queue_id})",
        map: match.map,
        winning_team_id: match.winning_team_id,

        match_participants: match.match_participants.map do |mp|
          {
            summoner_id: mp.summoner_id,
            summoner_name: mp.summoner&.name,
            summoner_tag: mp.summoner&.tag,
            champion_id: mp.champion_id,
            champion_name: mp.champion&.riot_id,
            champion_level: mp.champion_level,
            win: mp.win,
            kills: mp.kills,
            deaths: mp.deaths,
            assists: mp.assists,
            creep_score: mp.creep_score,
            vision_score: mp.vision_score,
            gold_earned: mp.gold_earned,
            damage_to_champions: mp.damage_to_champions,
            lane: mp.lane,
            role: mp.role,
            region: mp.summoner&.region,
          }
        end
      }
    end
  end
end