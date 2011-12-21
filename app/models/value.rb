class Value < ActiveRecord::Base

  belongs_to :coordinate
  belongs_to :moment
  belongs_to :setup
  
  validates :result, :presence => true, :numericality => true
end
