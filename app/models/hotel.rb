class Hotel < ApplicationRecord
  has_many :instagram_posts
  after_create :set_location_id

  REFERENCE_TYPES = {
    tag: 'tag',
    location: 'location'
  }

  def set_location_id
    update_attribute(
      :location_id,
      InstagramApi.get_location_id({
        lat: latitude,
        lon: longitude,
        hotel_id: id
      })
    ) if latitude && longitude
  end

  def tag_name
    name.downcase.tr(" ", "_")
  end

  def name_permutation
    name.downcase.split(' ').permutation.to_a
  end

  def tag_variations
    name_permutation.map { |x| x.join('_') }
  end

  def name_variations
    name_permutation.map { |x| x.join(' ') }
  end
end
