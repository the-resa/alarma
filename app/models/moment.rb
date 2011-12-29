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

    result = Array.new_2d(258, 228)
    
    data.each do |d|
      result[d.attributes["x"]][d.attributes["y"]] = d.attributes["result"]
    end

    result
  end
  
end
