class ScrapeMediaList
  def initialize(hotel_data)
    @type = hotel_data.keys.first.to_s
    @item = hotel_data[@type.to_sym]
    @hotel_id = hotel_data[:hotel_id]
    @all_nodes = []

    return if page_data(hotel_data[@type.to_sym])[@type]['media']['count'].zero?
    get_all_nodes
  end

  def perform
    @all_nodes.flatten.each do |node|
      next if Time.at(node['date']) <= DateTime.new(2014, 01, 01)
      commit_media(node)
    end
  end

  def commit_media(node)
    poster =
      Poster.create_with(
               username: username(node['code']),
               followers_count: poster_followers_count(username(node['code'])))
            .find_or_create_by(owner_id: node['owner']['id'])

    post = hotel.instagram_posts.find_by(code: node['code'])

    if post
      unless node['likes']['count'] == post.likes &&
             node['comments']['count'] == post.comments_count
        post.likes = node['likes']['count']
        post.comments_count = node['likes']['count']
        post.save
      end
    else
      create_new_instagram_post(node, poster)
    end
  end

  def create_new_instagram_post(node, poster)
    InstagramPost.create(
      date_time: Time.at(node['date']),
      media_link: node['display_src'],
      likes: node['likes']['count'],
      comments_count: node['comments']['count'],
      hotel_id: @hotel_id,
      code: node['code'],
      caption: node['caption'],
      poster_id: poster.id,
      reference_type: Hotel::REFERENCE_TYPES[@type.to_sym]
    )
  end

  def get_all_nodes(end_cursor=nil)
    page_data = page_data(@item, end_cursor)
    @all_nodes << page_data.dig(@type,'media','nodes')

    unless page_data.dig(@type,'media','page_info','end_cursor').blank?
      get_all_nodes(page_data.dig(@type,'media','page_info','end_cursor'))
    end
  end

  def page_data(item, end_cursor=nil)
    json = HTTParty.get(URI.encode(InstagramApi.media_list_path(item, end_cursor)))
  end

  def username(code)
    json = HTTParty.get(InstagramApi.media_path(code))
    json.dig('graphql','shortcode_media','owner','username')
  end

  def poster_followers_count(username)
    json = HTTParty.get(InstagramApi.user_path(username))
    json.dig('user','followed_by','count')
  end

  def hotel
    @hotel = Hotel.find(@hotel_id)
  end
end
