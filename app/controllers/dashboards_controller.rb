class DashboardsController < ApplicationController
 
  require 'oauth2'
  before_filter :renew_token, :only => [:show]

  def index
    redirect_to bime_client.auth_code.authorize_url(:redirect_uri => "http://localhost:3001/dashboards/callback")
  end

 def callback
 	if(params[:code])
	     access_token = bime_client.auth_code.get_token(params[:code], :redirect_uri => "http://localhost:3001/dashboards/callback")

       @client.site = "http://api.example.com:3000"
       token = OAuth2::AccessToken.new(@client,access_token.token, {:headers => {"oauth.token" => access_token.token }})
       p token.headers
       resp = token.get("/v2/dashboards")
       json = JSON.parse(resp.body)
       render :json => json
  	end
 end

 def show
   resp = @access_token.get("/v2/dashboards/#{params[:id]}")
   render :json => JSON.parse(resp.body)
 end


private
  def bime_client
  	@client ||= OAuth2::Client.new('gaClfxkgyRzfsdykDWONpyVFOE73JxzijZbYJHn9', 'rRf0ktbFFSoYizdH8fMNgfpwKAZFrI2gQTOgi5Ed',
		    :site => 'http://toto3.example.com:3000',
      	:request_token_path => "/oauth/request_token",
      	:access_token_path  => "/oauth/access_token",
      	:authorize_path     => "/oauth/authorize",
      	:parse_json => true,
        :raise_error => false
	)
  end

  def renew_token
    #@access_token = bime_client "thwwshRK5p4Hv1haj5LR"
  end
end
