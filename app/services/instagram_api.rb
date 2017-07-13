require 'capybara/poltergeist'

class InstagramApi
  class << self
    def request_access_token
      session = Capybara::Session.new(:poltergeist)
      session.visit(Instagram.authorize_url(redirect_uri: 'http://localhost:3000/callback', scope: 'public_content'))
      session.fill_in('username', with: ENV['instagram_user'])
      session.fill_in('password', with: ENV['instagram_password'])
      session.first('.button-green').click
      #session.first('.confirm').click
    end

    def get_location_id(coordinates = {})
      get_access_token = HTTParty.get('http://localhost:3000/get_access_token')
      client = Instagram.client(:access_token => JSON.parse(get_access_token.body)['access_token'])
      begin
        location = client.location_search(coordinates.fetch(:lat), coordinates.fetch(:lon), '5000')
      rescue Instagram::BadRequest => e
        if e.message.include? "400: The access_token provided is invalid"
          request_access_token
          get_location_id(coordinates)
        end
      end
      location.first['id'].to_i if location
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
