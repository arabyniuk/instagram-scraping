class AddLocationIdToHotels < ActiveRecord::Migration[5.0]
  def change
    add_column :hotels, :location_id, :integer, limit: 32
  end
end
