class MapdiffController < ApplicationController
  respond_to :json

  def index
    data = { :map => "diff",
      :model_name => params[:model],
      :scenario_name => params[:scenario],
      :year_a => params[:year_a],
      :year_b => params[:year_b],
      :month_a => params[:month_a],
      :month_b => params[:month_b]
    }

    if params[:var] == "all"
        pre = Moment.diff(params[:year_a], params[:month_a], params[:year_b], params[:month_b], Setup::VARIABLES[:pre])
        tmp = Moment.diff(params[:year_a], params[:month_a], params[:year_b], params[:month_b], Setup::VARIABLES[:tmp])
        gdd = Moment.diff(params[:year_a], params[:month_a], params[:year_b], params[:month_b], Setup::VARIABLES[:gdd])

      data[:data] = {
        :pre => pre,
        :tmp => tmp,
        :gdd => gdd
      }
    else
      var = params[:var].to_sym
      values = Moment.diff(params[:year_a], params[:month_a], params[:year_b], params[:month_b], Setup::VARIABLES[var])
      data[:data] = {var => values}
    end
    
    respond_with(data)
  end
end
