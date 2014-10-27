class DashboardsController < ApplicationController

  require 'oauth2'

  def index
    redirect_to bime_client.auth_code.authorize_url(:redirect_uri => "http://localhost:3000/dashboards/list")
  end

  def list
    if(params[:code])
      # Exchange the code with an access_token
      access_token = bime_client.auth_code.get_token(params[:code], :redirect_uri => "http://localhost:3000/dashboards/list") # store the token to future calls
      @client.site = "https://api.bime.io" # After you authorized your app, define the API endpoint
      resp = access_token.get('/v3/dashboards/')
      @dashboards = JSON.parse(resp.body)["result"]
    end
  end

  def show
    # Re create the access token based on the token saved
    access_token = OAuth2::AccessToken.new(bime_client,'<previously acquired access token>')
    @client.site = 'https://api.bime.io'
    # Get the dashboard the user wants to see
    resp = access_token.get "v3/dashboards/" + params[:id]
    @dashboard = JSON.parse(resp.body)["result"]
  end
end
