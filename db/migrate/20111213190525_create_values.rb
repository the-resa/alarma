class CreateValues < ActiveRecord::Migration
  def change
    create_table :values do |t|
      t.integer :zone, :default => Value::ZONES[:europe]
      t.integer :scenario, :default => Value::SCENARIOS[:bambu]
      t.boolean :var
      t.float :result
      t.references :moment

      t.timestamps
    end
  end
end
