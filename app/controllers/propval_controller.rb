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
      if params[:var] != "all"
        value = Prop.val_month(params[:year], params[:month], Setup::VARIABLES[:pre], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        data[params[:var].to_sym] = value if params[:var] != all
      else
        pre = Prop.val_month(params[:year], params[:month], Setup::VARIABLES[:pre], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        tmp = Prop.val_month(params[:year], params[:month], Setup::VARIABLES[:tmp], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        gdd = Prop.val_month(params[:year], params[:month], Setup::VARIABLES[:gdd], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        data[:data] = {pre => pre, tmp => tmp, gdd => gdd}
      end
    elsif(params[:year].match(/\d+/))
      if params[:var] != "all"
        value = Prop.val_year(params[:year], Setup::VARIABLES[:pre], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        data[params[:var].to_sym] = value
      else
        pre = Prop.val_year(params[:year], Setup::VARIABLES[:pre], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        tmp = Prop.val_year(params[:year], Setup::VARIABLES[:tmp], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        gdd = Prop.val_year(params[:year], Setup::VARIABLES[:gdd], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        data[:data] = {:pre => pre, :tmp => tmp, :gdd => gdd}
      end
    elsif(params[:year] == params[:month] && params[:month] == "all")
      if params[:var] != "all"
        value = Prop.val_scenario(Setup::VARIABLES[:pre], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        data[params[:var].to_sym] = value
      else
        pre = Prop.val_scenario(Setup::VARIABLES[:pre], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        tmp = Prop.val_scenario(Setup::VARIABLES[:tmp], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        gdd = Prop.val_scenario(Setup::VARIABLES[:gdd], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
        data[:data] = {pre => pre, tmp => tmp, gdd => gdd}
      end
    else
      data = {:error => "Not a valid API call"}
    end

    respond_with(data)
  end
end
