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
end
