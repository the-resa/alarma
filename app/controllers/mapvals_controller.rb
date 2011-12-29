class MapvalsController < ApplicationController

  # GET /mapval/:model/:scenario/:year/:month/:var
  def get_all_values
    #moment = Moment.find_by_year_and_month(params[:year], params[:month])

    pre = Moment.data(params[:month], params[:year], Setup::VARIABLES[:pre])
    tmp = Moment.data(params[:month], params[:year], Setup::VARIABLES[:tmp])
    gdd = Moment.data(params[:month], params[:year], Setup::VARIABLES[:gdd])

    respond_to do |format|
      if params[:var] == "all"
        format.json {
          render :json => {
              "map" => "val",
              "model_name" => params[:model],
              "scenario_name" => params[:scenario],
              "data" => {
                "pre" => pre,
                "tmp" => tmp,
                "gdd" => gdd}
          }
        }
      end
    end
  end
  
end
