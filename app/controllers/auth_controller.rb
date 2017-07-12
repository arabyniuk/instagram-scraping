class AuthController < ApplicationController
  before_action :check_access_token, only: [:get_access_token], unless: -> { $access_token }

  def callback
    response = Instagram.get_access_token(params[:code], :redirect_uri => 'http://localhost:3000/callback')
    $access_token = response.access_token
    head :no_content
  end

  def get_access_token
    render :json => { access_token: $access_token }
  end

  private

  def check_access_token
    InstagramApi.request_access_token
  end
end
