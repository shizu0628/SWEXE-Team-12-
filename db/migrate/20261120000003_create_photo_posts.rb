class CreatePhotoPosts < ActiveRecord::Migration[8.1]
  def change
    create_table :photo_posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :spot, null: false, foreign_key: true
      t.string :image_url, null: false
      t.string :status, null: false, default: "審査中"

      t.timestamps
    end
  end
end