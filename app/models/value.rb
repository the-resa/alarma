class Value < ActiveRecord::Base

  belongs_to :coordinate
  belongs_to :moment
  has_many :setups
  
  validates :result, :presence => true, :numericality => true
end
