class Coordinate < ActiveRecord::Base

  has_and_belongs_to_many :moments
  has_many :values, :through => :moments

  validates :x, :presence => true, :numericality => true
  validates :y, :presence => true, :numericality => true
end
