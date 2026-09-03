class Champion::ChampionShowService < ApplicationService
  def execute
    @result = find_champion
    raise ActiveRecord::RecordNotFound, "Champion not found" unless @result
  end

  private

  def setup
    super
    @champion_id = @params[:id]
  end

  def find_champion
    Champion.find_by(id: @champion_id)
  end
end
