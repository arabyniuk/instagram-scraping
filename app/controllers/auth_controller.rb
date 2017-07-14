class AuthController < ApplicationController
  before_action :check_access_token, only: [:get_access_token], unless: -> { $access_token }

  def callback
    response = Instagram.get_access_token(params[:code], redirect_uri: "#{ENV['host']}/callback")
    $access_token = response.access_token
    puts "-----------"
    puts $access_token
    puts "-----------"
    head :no_content
  end

  def get_access_token
    render :json => { access_token: $access_token }
  end

  private

  def check_access_token
    puts "-----------"
    puts "request token"
    puts "-----------"
    InstagramApi.request_access_token
  end
end
