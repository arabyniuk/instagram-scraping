class Hotel < ApplicationRecord
  has_many :instagram_posts
  after_create :set_location_id

  def set_location_id
    update_attribute(
      :location_id,
      InstagramApi.get_location_id({lat: latitude, lon: longitude})
    ) if latitude && longitude
  end

  def tag_name
    name.downcase.tr(" ", "_")
  end
end
