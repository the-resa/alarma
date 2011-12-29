class Moment < ActiveRecord::Base

  has_many :values
  has_and_belongs_to_many :coordinates

  validates :year, :presence => true, :numericality => true
  validates :month, :presence => true, :numericality => true

  def self.data(year, month)
    data = Moment.find_by_sql ["SELECT c.x, c.y, v.result FROM moments m 
        LEFT JOIN coordinates_moments cm ON m.id = cm.moment_id
        LEFT JOIN coordinates c ON c.id = cm.coordinate_id
        LEFT JOIN `values` v ON m.id = v.moment_id
        WHERE m.year = ? AND m.month = ?", year, month]

    result = Array.new_2d(258, 228)
    
    data.each do |d|
      # result[d.attributes["x"]] =  Array.new if result[d.attributes["x"]].nil?
      result[d.attributes["x"]][d.attributes["y"]] = d.attributes["result"]
    end

    result
  end
  
end
