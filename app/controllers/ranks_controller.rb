class RanksController < ApplicationController
  skip_before_action :authenticate_request!

  def index
    respond_using_service(Rank::RankIndexService)
  end
end