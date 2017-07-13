class CreatePoster < ActiveRecord::Migration[5.0]
  def change
    create_table :posters do |t|
      t.string :username
      t.integer :followers_count
      t.integer :owner_id, limit: 20
    end
  end
end
