namespace :riot do
  desc "Test Riot API with key using RiotApiService"
  task test: :environment do
    begin
      # Step 1: Get PUUID by Riot ID
      account_data = Riot::RiotApiService.new(
        account_region: "americas", # big region
        path: "account/v1/accounts/by-riot-id/Predator/x9jg"
      ).run!

      puuid = account_data[:puuid]

      # Step 2: Get Summoner info by PUUID
      summoner_data = Riot::RiotApiService.new(
        region: "na1", # small region
        path: "summoner/v4/summoners/by-puuid/#{puuid}"
      ).run!

      puts "Summoner info:"
      puts "Level: #{summoner_data[:summonerLevel]}"
      puts "PUUID: #{summoner_data[:puuid]}"

    rescue => e
      puts "Error: #{e.message}"
    end
  end
end
