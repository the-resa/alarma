class PropvalController < ApplicationController
  respond_to :json

  def index
    data = {:pro => :val,
       :model_name => params[:model],
      :scenario_name => params[:scenario],
      :year => params[:year],
      :month => params[:month]
    }

    params[:model].downcase!
    params[:scenario].downcase!

    if(params[:month].to_i >= 1 && params[:month].to_i <=12)
      value = Prop.val_month(params[:year], params[:month], Setup::VARIABLES[:pre], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
      data[params[:var].to_sym] = value;
    elsif(params[:year].match(/\d+/))
      value = Prop.val_year(params[:year], Setup::VARIABLES[:pre], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
      data[params[:var].to_sym] = value
    elsif(params[:year] == params[:month] && params[:month] == "all")
      value = Prop.val_scenario(Setup::VARIABLES[:pre], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
      data[params[:var].to_sym] = value
    else
      data = {:error => "Not a valid API call"}
    end

    respond_with(data)
  end
end
