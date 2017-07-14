class ScrapePosterInfo
  def initialize(args)
    @username = args[:username]
    @poster = Poster.find_by(username: @username)
  end

  def perform
    if @poster.followers_count != user_info.dig('user','followed_by','count')
      @poster.followers_count = user_info.dig('user','followed_by','count')
      @poster.save
    end
  end

  def user_info
    json = HTTParty.get(InstagramApi.user_path(@username))
  end
end

