class PropdiffController < ApplicationController
  respond_to :json

  def index

    data = {:pro => :diff,
      :model_name => params[:model],
      :scenario_name => params[:scenario]}

    params[:model].downcase!
    params[:scenario].downcase!

    if params[:function_a]
      data.merge!({:year_a => params[:year_a],
          :year_b => params[:year_b],
          :function => params[:function_a]})
      if(params[:var] == "all")
        pre = Prop.funct_diff(params[:year_a], params[:year_b], Setup::VARIABLES[:pre], params[:function_a], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        tmp = Prop.funct_diff(params[:year_a], params[:year_b], Setup::VARIABLES[:tmp], params[:function_a], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        gdd = Prop.funct_diff(params[:year_a], params[:year_b], Setup::VARIABLES[:gdd], params[:function_a], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        data[:data] = {:pre => pre, :tmp => tmp, :gdd => gdd}
      else
        value = Prop.funct_diff(params[:year_a], params[:year_b], Setup::VARIABLES[params[:var].to_sym], params[:function_a], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        data[:data] = {params[:var].to_sym => value}
      end
    elsif params[:month_a]
      value = Prop.diff_all(params)
    else
      data = {:error => "Not a valid API call"}
    end

    respond_with(data)
  end
end
