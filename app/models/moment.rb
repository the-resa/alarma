class Moment < ActiveRecord::Base

  has_many :values

  validates :year, :presence => true, :numericality => true
  validates :month, :presence => true, :numericality => true
end
