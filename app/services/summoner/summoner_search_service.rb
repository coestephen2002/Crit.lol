class Summoner::SummonerSearchService < ApplicationService

  def execute
    perform_search
  end

  private

  def setup
    super
    @region = @params[:region]
    @search_prompt = @params[:search_prompt]&.strip
    @name, @tag = @search_prompt&.downcase.split('#', 2)&.map(&:strip)
    @result = []
  end

  def perform_search
    return [] if @name.blank?

    if @tag.present?
      exact = RiotSummonerConcern::cached_summoner(name: @name, tag: @tag, region: @region)
      @result << exact if exact

      @result += RiotSummonerConcern::search_cached_summoners(name: @name, tag: @tag, region: @region)
                    .where.not(id: exact&.id)
    else
      @result += RiotSummonerConcern::search_cached_summoners(name: @name, region: @region)
    end

    @result.uniq
  end
end
