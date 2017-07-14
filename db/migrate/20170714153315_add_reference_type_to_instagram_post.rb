class AddReferenceTypeToInstagramPost < ActiveRecord::Migration[5.0]
  def change
    add_column :instagram_posts, :reference_type, :string
  end
end
