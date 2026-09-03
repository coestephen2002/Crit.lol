class MatchesController < ApplicationController
  skip_before_action :authenticate_request!

  def index
    respond_using_service(Match::MatchIndexService)
  end
end