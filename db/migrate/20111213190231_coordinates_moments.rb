class CoordinatesMoments < ActiveRecord::Migration
  def change
    create_table :coordinates_moments, :id => false do |t|
      t.integer :coordinate_id
      t.integer :moment_id
    end
  end
end
