class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def bime_client
    # Define your client app
    @client ||= OAuth2::Client.new('<application key>', '<application secret>',
                                   :site => 'https://<your subdomain>.bime.io', #Replace <your subdomain> by your account name
                                   :parse_json => true
    )
  end
end
