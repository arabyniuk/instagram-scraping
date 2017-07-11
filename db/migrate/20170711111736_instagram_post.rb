class InstagramPost < ActiveRecord::Migration[5.0]
  def change
    create_table :instagram_posts do |t|
      t.date :date
      t.string :photo
      t.integer :likes
      t.string :poster
      t.integer :poster_followers_count
      t.integer :comments_count

      t.integer :hotel_id
    end
  end
end
