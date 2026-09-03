class Champion::ChampionSearchService < ApplicationService
  def execute
    perform_search
  end

  private

  def setup
    super
    @search_prompt = @params[:search_prompt]&.strip
    @result = []
  end

  def perform_search
    return [] if @search_prompt.blank?
    return [] if @search_prompt.include?("#")

    @result = Champion.where("name ILIKE ? OR name ILIKE ?", "#{@search_prompt}%", "%#{@search_prompt}%")
                      .order(Arel.sql("CASE
                      WHEN name ILIKE '#{@search_prompt}%' THEN 0
                      ELSE 1
                    END, name"))
                      .limit(3)

    if @result.any? { |champ| champ.name.downcase.start_with?(@search_prompt.downcase) }
      @result
    else
      @result = []
    end
  end
end
