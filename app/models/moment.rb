class Moment < ActiveRecord::Base

  has_many :values

  validates :year, :presence => true, :numericality => true
  validates :month, :presence => true, :numericality => true


  def self.data(year, month, variable=1)
    data = Moment.find_by_sql ["SELECT c.x, c.y, v.result FROM coordinates c
        LEFT JOIN `values` v ON c.id = v.coordinate_id
        LEFT JOIN setups s ON s.id = v.setup_id
        LEFT JOIN moments m ON m.id = v.moment_id
        WHERE m.year = ? AND m.month = ? AND s.variable = #{variable}", year, month]

    render_data data
  end

  def self.funct(year, variable=1, funct="avg")
    data = Moment.find_by_sql ["SELECT c.x, c.y, #{funct.to_s}(v.result) AS result FROM coordinates c
        LEFT JOIN `values` v ON c.id = v.coordinate_id
        LEFT JOIN setups s ON s.id = v.setup_id
        LEFT JOIN moments m ON m.id = v.moment_id
        WHERE m.year = ? AND s.variable = #{variable}
        GROUP BY m.month, m.year", year]

    render_data data
  end

  def self.render_data data
    result = Array.new_2d(258, 228)
    
    data.each do |d|
      result[d.attributes["x"]][d.attributes["y"]] = d.attributes["result"]
    end
    
    result
  end
end
