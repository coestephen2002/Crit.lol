# config/initializers/rack_attack.rb
class Rack::Attack
  throttle('req/ip', limit: 100, period: 10.minutes) do |req|
    req.ip
  end

  ### Throttle logins by IP ###
  throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
    if req.path == '/api/accounts/login' && req.post?
      req.ip
    end
  end

  ### Throttle signups by IP ###
  throttle('signups/ip', limit: 3, period: 1.minute) do |req|
    if req.path == '/api/accounts' && req.post?
      req.ip
    end
  end

  ### Block requests from bad user agents ###
  blocklist('block bad user agents') do |req|
    req.user_agent =~ /malicious-bot/i
  end

  ### Custom response for throttled requests ###
  self.throttled_response = lambda do |env|
    [
      429,
      { 'Content-Type' => 'application/json' },
      [{ error: 'Rate limit exceeded.' }.to_json]
    ]
  end
end
