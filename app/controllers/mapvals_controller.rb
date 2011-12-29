class MapvalsController < ApplicationController


  def index
    if params[:var] == "all"
      get_all_values
    else
      get_values
    end
  end


    
  # GET /mapval/:model/:scenario/:year/:month/:var
  def get_all_values
    #moment = Moment.find_by_year_and_month(params[:year], params[:month])

    pre = Moment.data(params[:year], params[:month], Setup::VARIABLES[:pre])
    tmp = Moment.data(params[:year], params[:month], Setup::VARIABLES[:tmp])
    gdd = Moment.data(params[:year], params[:month], Setup::VARIABLES[:gdd])

    respond_to do |format|
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

  def get_values
    #moment = Moment.find_by_year_and_month(params[:year], params[:month])
    var = params[:var].to_sym
    values = Moment.data(params[:year], params[:month], Setup::VARIABLES[var])
    puts "gehhhht #{params[:var].to_s}"

    respond_to do |format|
        format.json {
          render :json => {
              "map" => "val",
              "model_name" => params[:model],
              "scenario_name" => params[:scenario],
              "data" => {
                "#{params[:var].to_s}" => values}
          }
        }
    end
  end
  
end
