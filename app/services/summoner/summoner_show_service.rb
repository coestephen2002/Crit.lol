class Summoner::SummonerShowService < ApplicationService

  private

  def setup
    super
    @region = @params[:region]
    @search_prompt = @params[:search_prompt]
    @name, @tag = @search_prompt&.split('#', 2).map(&:strip)
  end
  
  def execute
    @result = RiotSummonerConcern::fetch_or_create_summoner(name: @name, tag: @tag, region: @region)
    raise ActiveRecord::RecordNotFound, "Summoner not found" unless @result
  end
end
