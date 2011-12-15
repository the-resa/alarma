class Value < ActiveRecord::Base

  belongs_to :moment

  ZONES = {
    :europe => 1,
    :australia => 2,
    :amerika => 3
  }

  SCENARIOS = {
    :bambu => 1,
    :gras => 2,
    :sedg => 3
  }

  validates :zone, :numericality => {:greater_than => 0, :less_than => 4}
  validates :scenario, :numericality => {:greater_than => 0, :less_than => 4}
  validates :var, :inclusion => {:in => [true, false]}
  validates :result, :presence => true
end
