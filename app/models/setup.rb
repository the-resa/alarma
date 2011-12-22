class Setup < ActiveRecord::Base

  has_many :values

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

  VARIABLES = {
    :pre => 1,
    :tmp => 2,
    :gdd => 3
  }

  validates :zone, :numericality => {:greater_than => 0, :less_than => 4}
  validates :scenario, :numericality => {:greater_than => 0, :less_than => 4}
  validates :variable, :numericality => {:greater_than => 0, :less_than => 4}
end
