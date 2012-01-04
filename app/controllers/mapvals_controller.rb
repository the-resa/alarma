class MapvalsController < ApplicationController
  respond_to :json

  # GET /mapval/:model/:scenario/:year/:month/:var

  def index

    data = { :map => "val",
      :model_name => params[:model],
      :scenario_name => params[:scenario],
      :year => params[:year]
    }

    if FUNCTIONS.include? params[:month]
      if params[:var] == "all"
        pre = Moment.funct(params[:year], Setup::VARIABLES[:pre] ,params[:month])
        tmp = Moment.funct(params[:year], Setup::VARIABLES[:tmp] ,params[:month])
        gdd = Moment.funct(params[:year], Setup::VARIABLES[:gdd] ,params[:month])

        data[:data] = {
          :pre => pre,
          :tmp => tmp,
          :gdd => gdd
        }
      else
        var = params[:var].to_sym
        values = Moment.funct(params[:year], Setup::VARIABLES[var] ,params[:month])

        data[:data] = {"#{params[:var].to_s}" => values}
      end

      data[:function] = params[:month]
    elsif (params[:month].to_i >= 1 && params[:month].to_i <=12)
    
      if params[:var] == "all"
        pre = Moment.data(params[:year], params[:month], Setup::VARIABLES[:pre])
        tmp = Moment.data(params[:year], params[:month], Setup::VARIABLES[:tmp])
        gdd = Moment.data(params[:year], params[:month], Setup::VARIABLES[:gdd])

        data[:data] = {
          :pre => pre,
          :tmp => tmp,
          :gdd => gdd
        }
      else
        var = params[:var].to_sym
        values = Moment.data(params[:year], params[:month], Setup::VARIABLES[var])

        data[:data] = {"#{params[:var].to_s}" => values}
      end

      data[:month] = params[:month]
    else
      data = {:error => "Not a valid API call"}
    end

    respond_with(data)
  end  
end
