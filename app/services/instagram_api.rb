require 'capybara/poltergeist'

class InstagramApi
  class << self
    def request_access_token
      session = Capybara::Session.new(:poltergeist)

      session.visit(Instagram.authorize_url(redirect_uri: "#{ENV['host']}/callback", scope: 'public_content'))
      session.fill_in('username', with: ENV['instagram_user'])
      session.fill_in('password', with: ENV['instagram_password'])
      session.first('.button-green').click
      #session.first('.confirm').click
    end

    def get_location_id(params = {})
      get_access_token = HTTParty.get("#{ENV['host']}/get_access_token")
      client = Instagram.client(access_token: JSON.parse(get_access_token.body)['access_token'])
      begin
        location = client.location_search(params.fetch(:lat), params.fetch(:lon), '5000')
      rescue Instagram::BadRequest => e
        if e.message.include? "400: The access_token provided is invalid"
          request_access_token
          get_location_id(params)
        end
      end
      if location
        best_location_match(location, params[:hotel_id]).fetch('id', nil)
      end
    end

    def best_location_match(location, hotel_id)
      location.find do |obj|
        hotel_name_variations(hotel_id).any? do |name_variation|
          obj['name'].include? name_variation
        end
      end || {}
    end

    def hotel_name_variations(hotel_id)
      hotel(hotel_id).name_variations + [hotel(hotel_id).name_japanese]
    end

    def hotel(id)
      Hotel.find(id)
    end

    def media_list_path(item, end_cursor = nil)
      if item.is_a? Integer
       "https://www.instagram.com/explore/locations/#{item}/?__a=1#{max_id(end_cursor)}"
      else
        "https://www.instagram.com/explore/tags/#{item}/?__a=1#{max_id(end_cursor)}"
      end
    end

    def max_id(end_cursor)
      end_cursor ? "&max_id=#{end_cursor}" : ""
    end

    def media_path(code)
      "https://www.instagram.com/p/#{code}/?__a=1"
    end

    def user_path(username)
      "https://www.instagram.com/#{username}/?__a=1"
    end
  end
end
