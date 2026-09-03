class SummonersController < ApplicationController
  skip_before_action :authenticate_request!, only: [:show, :search]

  def show
    respond_using_service(Summoner::SummonerShowService)
  end

  def search
    respond_using_service(Summoner::SummonerSearchService)
  end
end