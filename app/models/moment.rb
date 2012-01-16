class Moment < ActiveRecord::Base

  has_many :values

  validates :year, :presence => true, :numericality => true
  validates :month, :presence => true, :numericality => true

  def self.data(year, month, variable, model, scenario)
    data = Moment.find_by_sql ["SELECT c.x, c.y, v.result FROM coordinates c
        LEFT JOIN `values` v ON c.id = v.coordinate_id
        LEFT JOIN setups s ON s.id = v.setup_id
        LEFT JOIN moments m ON m.id = v.moment_id
        WHERE m.year = ? AND m.month = ? AND s.variable = #{variable} AND s.zone = ? AND s.scenario = ?",
        year, month, model, scenario]

    render_data data
  end

  def self.funct (year, variable=1, funct='avg', model, scenario)
    data = Moment.find_by_sql ["SELECT c.x, c.y, #{funct.to_s}(v.result) AS result FROM coordinates c
        LEFT JOIN `values` v ON c.id = v.coordinate_id
        LEFT JOIN setups s ON s.id = v.setup_id
        LEFT JOIN moments m ON m.id = v.moment_id
        WHERE m.year = ? AND s.variable = #{variable} AND s.zone = ? AND s.scenario = ?
        GROUP BY m.month, m.year", year, model, scenario]

    render_data data
  end

  def self.diff(year_a, month_a, year_b, month_b, variable=1, model, scenario)
    data_a = data(year_a, month_a, variable, model, scenario)
    data_b = data(year_b, month_b, variable, model, scenario)


    data_a.each_with_index do |value,x|
      next if value.nil?
      value.each_with_index do |v, y|
        if !data_a[x][y].nil? && !data_b[x][y].nil?
          data_a[x][y] = data_a[x][y] - data_b[x][y]
        end
      end
    end

    data_a
  end

  def self.diff_funct(year_a, year_b, variable=1, funct_a="avg", funct_b="avg", model, scenario)
    data_a = funct(year_a, variable, funct_a)
    data_b = funct(year_b, variable, funct_b)

    data_a.each_with_index do |value,x|
      next if value.nil?
      value.each_with_index do |v, y|
        if !data_a[x][y].nil? && !data_b[x][y].nil?
          data_a[x][y] = data_a[x][y] - data_b[x][y]
        end
      end
    end

    data_a

  end

  def self.render_data data
    result = Array.new_2d(258, 228)
    
    data.each do |d|
      result[d.attributes["x"]][d.attributes["y"]] = d.attributes["result"]
    end
    
    result
  end

  def self.render_single_data data
    data = data.first
    {:min => data[:min], :max => data[:max], :avg => data[:avg]} if !data.nil?
  end
end

