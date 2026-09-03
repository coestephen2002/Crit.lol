require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RefactoryApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.active_job.queue_adapter = :sidekiq

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end

    config.middleware.use Rack::Attack

    config.api_only = true
  end
end
