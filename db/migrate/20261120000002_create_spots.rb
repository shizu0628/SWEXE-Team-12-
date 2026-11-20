class CreateSpots < ActiveRecord::Migration[8.1]
  def change
    create_table :spots do |t|
      t.string :name, null: false
      t.text :description
      t.integer :reward_points, null: false, default: 100

      t.timestamps
    end
  end
end