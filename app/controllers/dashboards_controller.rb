class DashboardsController < ApplicationController
 
  require 'oauth2'

  def index
    redirect_to bime_client.auth_code.authorize_url(:redirect_uri => "http://localhost:3000/dashboards/callback")
  end

 def callback
 	if(params[:code])
	    begin
	      access_token = bime_client.auth_code.get_access_token(params[:code], :redirect_uri => "http://localhost:3000/dashboards/callback")
	      access_token.get('/dashboards')
	    rescue OAuth2::HTTPError => e
	      render :text => e.response.body
	    end
  	end
 end

private
  def bime_client 
  	client = OAuth2::Client.new('lhiA3Fc2MNIK0mLXmorm', 'sVB1fOyeS8pRjBIeRMbuoVmoFfteZJ0OvpjcS7QJ', 
		:site => 'https://bigquery.paperboyapp.com/',
      	:request_token_path => "/oauth/request_token",
      	:access_token_path  => "/oauth/access_token",
      	:authorize_path     => "/oauth/authorize",
      	:parse_json => true
	)
  end

end
