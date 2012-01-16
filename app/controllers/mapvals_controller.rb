class MapvalsController < ApplicationController
  respond_to :json

  # GET /mapval/:model/:scenario/:year/:month/:var

  def index

    data = { :map => "val",
      :model_name => params[:model],
      :scenario_name => params[:scenario],
      :year => params[:year]
    }

    params[:model].downcase!
    params[:scenario].downcase!

    puts "Scenario #{Setup::ZONES[params[:model]]}"

    if FUNCTIONS.include? params[:month]
      if params[:var] == "all"
        pre = Moment.funct(params[:year], Setup::VARIABLES[:pre] ,params[:month], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        tmp = Moment.funct(params[:year], Setup::VARIABLES[:tmp] ,params[:month], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        gdd = Moment.funct(params[:year], Setup::VARIABLES[:gdd] ,params[:month], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])

        data[:data] = {
          :pre => pre,
          :tmp => tmp,
          :gdd => gdd
        }
      else
        var = params[:var].to_sym
        values = Moment.funct(params[:year], Setup::VARIABLES[var] ,params[:month], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])

        data[:data] = {"#{params[:var].to_s}" => values}
      end

      data[:function] = params[:month]
    elsif (params[:month].to_i >= 1 && params[:month].to_i <=12)
    
      if params[:var] == "all"
        pre = Moment.data(params[:year], params[:month], Setup::VARIABLES[:pre], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        tmp = Moment.data(params[:year], params[:month], Setup::VARIABLES[:tmp], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        gdd = Moment.data(params[:year], params[:month], Setup::VARIABLES[:gdd], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])

        data[:data] = {
          :pre => pre,
          :tmp => tmp,
          :gdd => gdd
        }
      else
        var = params[:var].to_sym
        values = Moment.data(params[:year], params[:month], Setup::VARIABLES[var], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])

        data[:data] = {"#{params[:var].to_s}" => values}
      end

      data[:month] = params[:month]
    else
      data = {:error => "Not a valid API call"}
    end

    respond_with(data)
  end  
end
