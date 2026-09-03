class ChampionsController < ApplicationController
  skip_before_action :authenticate_request!

  def index
    respond_with(Champion.all)
  end
  def show
    respond_using_service(Champion::ChampionShowService)
  end

  def search
    respond_using_service(Champion::ChampionSearchService)
  end
end