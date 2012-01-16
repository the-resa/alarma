class MapdiffController < ApplicationController
  respond_to :json

  def index
    data = { :map => "diff",
      :model_name => params[:model],
      :scenario_name => params[:scenario],
      :year_a => params[:year_a],
      :year_b => params[:year_b]
    }

        params[:model].downcase!
    params[:scenario].downcase!

    if (FUNCTIONS.include? params[:month_a]) && (FUNCTIONS.include? params[:month_b])
      if params[:var] == "all"
        pre = Moment.diff_funct(params[:year_a], params[:year_b], Setup::VARIABLES[:pre], params[:month_a], params[:month_b], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        tmp = Moment.diff_funct(params[:year_a], params[:year_b], Setup::VARIABLES[:tmp], params[:month_a], params[:month_b], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        gdd = Moment.diff_funct(params[:year_a], params[:year_b], Setup::VARIABLES[:gdd], params[:month_a], params[:month_b], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])

        data[:data] = {
          :pre => pre,
          :tmp => tmp,
          :gdd => gdd
        }
        
      else
        var = params[:var].to_sym
        values = Moment.diff_funct(params[:year_a], params[:year_b], Setup::VARIABLES[var], params[:month_a], params[:month_b], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        data[:data] = {var => values}
      end

      data[:function] = params[:month_a]
      
    elsif (params[:month_a].to_i >= 1 && params[:month_a].to_i <=12)
      if params[:var] == "all"
        pre = Moment.diff(params[:year_a], params[:month_a], params[:year_b], params[:month_b], Setup::VARIABLES[:pre], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        tmp = Moment.diff(params[:year_a], params[:month_a], params[:year_b], params[:month_b], Setup::VARIABLES[:tmp], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        gdd = Moment.diff(params[:year_a], params[:month_a], params[:year_b], params[:month_b], Setup::VARIABLES[:gdd], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])

        data[:data] = {
          :pre => pre,
          :tmp => tmp,
          :gdd => gdd
        }
      else
        var = params[:var].to_sym
        values = Moment.diff(params[:year_a], params[:month_a], params[:year_b], params[:month_b], Setup::VARIABLES[var], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        data[:data] = {var => values}
      end

      data[:month_a] = params[:month_a]
      data[:month_b] = params[:month_b]
    else
      data = {:error => "Not a valid API call"}
    end
    respond_with(data)
  end
end
