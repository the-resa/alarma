class CreateValues < ActiveRecord::Migration
  def change
    create_table :values do |t|
      t.float :result
      t.references :coordinate
      t.references :moment

      t.timestamps
    end
  end
end
