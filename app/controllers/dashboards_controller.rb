class DashboardsController < ApplicationController
 
  require 'oauth2'

  def index
    redirect_to bime_client.auth_code.authorize_url(:redirect_uri => "http://localhost:3000/dashboards/list")
  end

 def list
 	if(params[:code])
	   access_token = bime_client.auth_code.get_token(params[:code], :redirect_uri => "http://localhost:3000/dashboards/list")
     @client.site = "https://api.paperboyapp.com"
	   resp = access_token.get('/v2/dashboards')
     @dashboards = JSON.parse(resp.body)["result"]
     @bime_user = current_user.get_or_create_named_user(access_token)
     
	end
 end

def show

end

private
  def bime_client 
  	@client ||= OAuth2::Client.new('vVzhk5FyzizLLe051J5HjUHpKVBrgAou0KvRsx4z', 'IO7DzytMDLxqjpxz3xflzpnHoUWx0o5qf5BOBl6U', 
		:site => 'https://yannick.paperboyapp.com/',
      	:request_token_path => "/oauth/request_token",
      	:access_token_path  => "/oauth/access_token",
      	:authorize_path     => "/oauth/authorize",
      	:parse_json => true
	)
  end
end
