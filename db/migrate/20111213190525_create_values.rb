class CreateValues < ActiveRecord::Migration
  def change
    create_table :values do |t|
      t.integer :zone
      t.integer :scenario
      t.boolean :var
      t.float :result

      t.references :moment

      t.timestamps
    end
  end
end
