class CreateMoments < ActiveRecord::Migration
  def change
    create_table :moments do |t|
      t.integer :year
      t.integer :month

      t.timestamps
    end
  end
end
