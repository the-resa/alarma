class Value < ActiveRecord::Base

  belongs_to :moment

  ZONES = {
    :europe => 0,
    :australia => 1,
    :amerika => 2
  }

  SCENARIOS = {
    :bambu => 0,
    :gras => 1,
    :sedg => 2
  }

  validates :zone, :presence => true, :inclusion => {:in => ZONES}
  validates :scenario, :presence => true, :inclusion => {:in => SCENARIOS}
  validates :var, :presence => true
  validates :result, :presence => true
end
