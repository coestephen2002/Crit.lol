class ChampionMasteriesController < ApplicationController
  skip_before_action :authenticate_request!
  def show
    respond_with(Summoner.find(params[:id]).top_masteries)
  end
end