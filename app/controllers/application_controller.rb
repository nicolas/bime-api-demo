class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  
  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def bime_client
    # Define your client app
    # OAuth2::Client.new(<consumer_key>,<consumer_secret>)
    # site : https://<your_bimeapp_account>.bimeapp.com

    @client ||= OAuth2::Client.new('gaClfxkgyRzfsdykDWONpyVFOE73JxzijZbYJHn9', 'rRf0ktbFFSoYizdH8fMNgfpwKAZFrI2gQTOgi5Ed',
                                   :site => 'https://yannick.bimeapp.com', #Replace yannick by your account name
                                   :request_token_path => "/oauth/request_token",
                                   :access_token_path  => "/oauth/access_token",
                                   :authorize_path     => "/oauth/authorize",
                                   :parse_json => true
    )
  end
end
