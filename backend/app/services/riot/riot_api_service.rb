class Riot::RiotApiService < ApplicationService
  def initialize(params)
    @params = params
  end

  def run!
    setup
    send_request
    validate_and_return_result
  end

  private

  def setup
    @api_key = Rails.application.credentials.dig(:riot, :api_key)
    raise "Riot API key not set" if @api_key.blank?

    @small_region = @params[:region]
    @big_region = @params[:account_region]
    @match_region = @params[:match_region]
    @path = @params[:path]
    @endpoint = build_endpoint
    @http_method = :get
    @query = @params[:query] || {}
  end

  def build_endpoint
    if @small_region.present?
      "https://#{@small_region}.api.riotgames.com/lol/#{@path}"
    elsif @big_region.present?
      "https://#{@big_region}.api.riotgames.com/riot/#{@path}"
    elsif @match_region.present?
      "https://#{@match_region}.api.riotgames.com/lol/#{@path}"
    else
      raise "Error: no region passed in to determine base endpoint."
    end
  end

  def send_request
    conn = Faraday.new(url: @endpoint) do |f|
      f.request :url_encoded
      f.response :raise_error
    end

    @response = conn.get do |req|
      req.headers['X-Riot-Token'] = @api_key
      req.params.update(@query) if @query.present?
    end
  rescue Faraday::ClientError => e
    raise "Riot API request failed #{e.message}"
  end

  def validate_and_return_result
    case @response.status
    when 200
      @result = JSON.parse(@response.body, symbolize_names: true)
    when 429
      raise "Rate limit exceeded."
    when 401, 403
      raise "Invalid API key"
    else
      raise "Unexpected riot api error: #{@response.status} - #{@response.body}"
    end

    @result
  end
end