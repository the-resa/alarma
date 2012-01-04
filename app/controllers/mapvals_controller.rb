class MapvalsController < ApplicationController
  respond_to :json

  # GET /mapval/:model/:scenario/:year/:month/:var

  def index

    data = { :map => "val",
            :model_name => params[:model],
            :scenario_name => params[:scenario]
    }
    
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

    respond_with(data)
  end


  
end
