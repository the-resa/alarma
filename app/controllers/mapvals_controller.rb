class MapvalsController < ApplicationController

  # GET /mapval/:model/:scenario/:year/:month/:var
  def get_all_values
    moment = Moment.find_by_year_and_month(params[:year], params[:month])
    
    respond_to do |format|
      if params[:var] == "all"
        format.json {
          render :json => {
              "map" => "val",
              "model_name" => params[:model],
              "scenario_name" => params[:scenario],
              "data" => {
                "pre" => [],
                "tmp" => [] }
          }
        }
      end
    end
  end
  
end
