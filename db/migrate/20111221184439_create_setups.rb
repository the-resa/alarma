class CreateSetups < ActiveRecord::Migration
  def change
    create_table :setups do |t|
      t.integer :zone, :default => Setup::ZONES[:europe]
      t.integer :scenario, :default => Setup::SCENARIOS[:bambu]
      t.integer :variable, :default => Setup::VARIABLES[:pre]
    end
  end
end
