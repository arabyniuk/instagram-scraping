class AddFieldsToInstagramPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :instagram_posts, :code, :string
    add_column :instagram_posts, :caption, :text
    add_column :instagram_posts, :poster_id, :integer, limit: 20
    rename_column :instagram_posts, :photo, :media_link
  end
end
