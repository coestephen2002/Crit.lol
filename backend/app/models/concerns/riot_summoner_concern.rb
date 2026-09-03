# app/services/concerns/riot_account_concern.rb
module RiotSummonerConcern
  extend ActiveSupport::Concern

  def self.fetch_or_create_summoner(name:, tag:, region:)
    summoner = cached_summoner(name: name, tag: tag, region: region) || create_summoner_from_riot(name: name, tag: tag, region: region)

    summoner.attributes.merge(
      "name_tag" => "#{summoner.name}-#{summoner.tag}"
    )
  end

  def self.remove_summoner(name:, tag:, region:)
    Summoner.where(name: name, tag: tag, region: region).delete_all
  end

  def self.refresh_summoner(summoner)
    return unless summoner
    
    account_data = Riot::RiotApiService.new(
      account_region: account_region,
      path: "account/v1/accounts/by-puuid/#{summoner.puuid}"
    ).run!

    return unless account_data
          
    summoner_data = Riot::RiotApiService.new(
      region: @region,
      path: "summoner/v4/summoners/by-puuid/#{summoner.puuid}"
    ).run!
    
    summoner.update!(
      name: account_data[:gameName],
      tag: account_data[:tagLine],
      summoner_level: summoner_data[:summonerLevel],
      profile_icon_id: summoner_data[:profileIconId],
      revision_date: summoner_data[:revisionDate]
    )
  end

  def self.search_cached_summoners(name:, tag: nil, region: nil, limit: 10)
    query = Summoner.all
    query = query.where(region: region) if region.present?

    if tag.present?
      query = query.where("name ILIKE ? AND tag ILIKE ?", "%#{name}%", "%#{tag}%")
                   .order(Arel.sql("CASE
                   WHEN name ILIKE '#{ActiveRecord::Base.sanitize_sql_like(name)}%'
                        AND tag ILIKE '#{ActiveRecord::Base.sanitize_sql_like(tag)}%'
                   THEN 0
                   ELSE 1
                 END, name"))
    else
      query = query.where("name ILIKE ?", "%#{name}%")
                   .order(Arel.sql("CASE
                   WHEN name ILIKE '#{ActiveRecord::Base.sanitize_sql_like(name)}%'
                   THEN 0
                   ELSE 1
                 END, name"))
    end

    results = query.limit(limit).to_a

    starts_with = results.select { |s| s.name.downcase.start_with?(name.downcase) }
    middle_matches = results.reject { |s| s.name.downcase.start_with?(name.downcase) }

    if starts_with.any?
      starts_with + middle_matches.first(3)
    else
      Summoner.none
    end
  end

  def self.cached_summoner(name:, tag:, region:)
     Summoner.where("LOWER(name) = ? AND LOWER(tag) = ? AND region = ?", name.downcase, tag.downcase, region).first
  end

  private
  
  def self.create_summoner_from_riot(name:, tag:, region:)

    account_region = RiotRegionConcern::routing_region_for(region)
    encoded_name, encoded_tag = ERB::Util.url_encode(name), ERB::Util.url_encode(tag)
    
    account_data = Riot::RiotApiService.new(
      account_region: account_region,
      path: "account/v1/accounts/by-riot-id/#{encoded_name}/#{encoded_tag}"
    ).run!

    puuid = account_data[:puuid]

    summoner_data = Riot::RiotApiService.new(
      region: region,
      path: "summoner/v4/summoners/by-puuid/#{puuid}"
    ).run!

    Summoner.find_or_create_by!(puuid: puuid) do |s|
      s.name = account_data[:gameName]
      s.tag = account_data[:tagLine]
      s.summoner_level = summoner_data[:summonerLevel]
      s.profile_icon_id = summoner_data[:profileIconId]
      s.revision_date = summoner_data[:revisionDate],
      s.region = region
    end
  end
end
