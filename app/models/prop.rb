class Prop < Moment
   def self.val_month(year, month, variable, model, scenario)
     data = Moment.find_by_sql ["SELECT min(v.result) AS min, max(v.result) AS max, avg(v.result) AS avg
        FROM coordinates c
        LEFT JOIN `values` v ON c.id = v.coordinate_id
        LEFT JOIN setups s ON s.id = v.setup_id
        LEFT JOIN moments m ON m.id = v.moment_id
        WHERE m.year = ? AND m.month = ? AND s.variable = #{variable} AND s.zone = ? AND s.scenario = ?
       GROUP BY m.month, m.year", year, month, model, scenario]

       render_single_data data
   end

   def self.val_year(year, variable, model, scenario)
     data = Moment.find_by_sql ["SELECT min(v.result) AS min, max(v.result) AS max, avg(v.result) AS avg
        FROM coordinates c
        LEFT JOIN `values` v ON c.id = v.coordinate_id
        LEFT JOIN setups s ON s.id = v.setup_id
        LEFT JOIN moments m ON m.id = v.moment_id
        WHERE m.year = ? AND s.variable = #{variable} AND s.zone = ? AND s.scenario = ?
       GROUP BY m.year", year, model, scenario]

       render_single_data data
   end

    def self.val_scenario(variable, model, scenario)
     data = Moment.find_by_sql ["SELECT min(v.result) AS min, max(v.result) AS max, avg(v.result) AS avg
        FROM coordinates c
        LEFT JOIN `values` v ON c.id = v.coordinate_id
        LEFT JOIN setups s ON s.id = v.setup_id
        LEFT JOIN moments m ON m.id = v.moment_id
        WHERE s.variable = #{variable} AND s.zone = ? AND s.scenario = ?
       GROUP BY m.year", model, scenario]

       render_single_data data
   end

    def self.funct_diff(year_a, year_b, variable, function, model, scenario)

      data_a = val_year(year_a, variable, model, scenario)
      data_b = val_year(year_b, variable, model, scenario)

      if(function == "all")
        data_a[:min] = data_b[:min] - data_a[:min]
        data_a[:max] = data_b[:max] - data_a[:max]
        data_a[:avg] = data_b[:avg] - data_a[:avg]
        
        data_a
      else
        data_a[function.to_sym] =  data_b[function.to_sym] - data_a[function.to_sym]
        {function.to_sym => data_a[function.to_sym]}
      end
    end

    def self.diff_all(params)
      data_a = val_month(params[:year_a], params[:month_a], Setup::VARIABLES[params[:var].to_sym], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])
      data_b = val_month(params[:year_b], params[:month_b], Setup::VARIABLES[params[:var].to_sym], Setup::ZONES[params[:model].to_sym], Setup::SCENARIOS[params[:scenario].to_sym])


      data_a[:min] = data_b[:min] - data_a[:min] if data_a[:min]
      data_a[:max] = data_b[:max] - data_a[:max] if data_a[:max]
      data_a[:avg] = data_b[:avg] - data_a[:avg] if data_a[:avg]

      data_a
    end
end
