class Coordinate < ActiveRecord::Base
  has_many :values

  validates :x, :presence => true, :numericality => true
  validates :y, :presence => true, :numericality => true
end
