Sidekiq.configure_server do |config|
  config.redis = { url: Rails.application.credentials.dig(:redis, :url) }
  config.on(:startup) do
    schedule_file = Rails.root.join('config/schedule.yml')

    if File.exist?(schedule_file)
      Sidekiq.schedule = YAML.load(ERB.new(File.read(schedule_file)).result) # supports ERB & env vars
      Sidekiq::Scheduler.reload_schedule!
    end
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: Rails.application.credentials.dig(:redis, :url) }
end