# lib/tasks/champions.rake
require 'open-uri'
require 'json'

namespace :champions do
  desc "Populate champions table from Riot's Data Dragon"
  task populate: :environment do
    base_url = "https://ddragon.leagueoflegends.com/cdn"
    version = JSON.parse(URI.open("https://ddragon.leagueoflegends.com/api/versions.json").read).first
    champions_url = "#{base_url}/#{version}/data/en_US/champion.json"

    puts "Fetching champions from #{champions_url}..."
    champions_data = JSON.parse(URI.open(champions_url).read)["data"]

    champions_data.each do |champ_id, champ_info|
      riot_id   = champ_info["id"]
      riot_key  = champ_info["key"].to_i
      name      = champ_info["name"]
      title     = champ_info["title"]
      tags      = champ_info["tags"] || []
      icon_url  = "#{base_url}/#{version}/img/champion/#{riot_id}.png"

      champion = Champion.find_or_initialize_by(riot_id: riot_id)
      champion.update!(
        name: name,
        title: title,
        riot_key: riot_key,
        tags: tags,
        icon_url: icon_url
      )
      puts "#{champion.name} (#{champion.riot_id})"
    end

    puts "Champions table populated successfully!"
  end
end
