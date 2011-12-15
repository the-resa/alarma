class Moment < ActiveRecord::Base

  has_many :values
  has_and_belongs_to_many :coordinates

  validates :year, :presence => true, :numericality => true
  validates :month, :presence => true, :numericality => true
end
