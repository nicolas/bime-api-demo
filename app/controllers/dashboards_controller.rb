class DashboardsController < ApplicationController

  require 'oauth2'

  def index
    redirect_to bime_client.auth_code.authorize_url(:redirect_uri => "http://localhost:3001/dashboards/list")
  end

  def list
    if(params[:code])
      # Exchange the code with an access_token
      access_token = bime_client.auth_code.get_token(params[:code], :redirect_uri => "http://localhost:3001/dashboards/list") # store the token to future calls
      @client.site = "http://api.example.com:3000" # After you authorized your app, define the API endpoint
      # Get the group named "Awesome Group" you can also get by ID
      resp = access_token.get('/v2/named_user_groups/1') do |r|
        r.params["name"] = "Awesome Group"
      end
      @group = JSON.parse(resp.body)["result"]
      # Get the Bime named user associated with the current user
      @bime_user = current_user.get_named_user(access_token)
      # If it does not exist create it and associate it with the group "WAC"
      @bime_user = current_user.create_named_user(access_token,@group) if @bime_user.nil?
      # Get the group WAC to list dashboards
      resp = access_token.get('/v2/named_user_groups/' + @bime_user["named_user_group_id"].to_s)
      @group = JSON.parse(resp.body)["result"]
      @dashboards = @group["dashboards"]
    end
  end

  def show
    dahsboard_id = params[:id]
    # Re create the access token based on the token saved
    access_token = OAuth2::AccessToken.new(bime_client,"VeJOmS8JjmjcIqRXHlXrrtGsIhmPK6gV46HMMx43")
    @client.site = "http://api.example.com:3000"
    # Get the dashboard the user wants to see
    resp = access_token.get "v2/dashboards/" + dahsboard_id
    @dashboard = JSON.parse(resp.body)["result"]
    # Get the named user for the current user
    @bime_user = current_user.get_named_user(access_token)
    # Get the access token from the response
    @access_token = @bime_user["access_token"]
    # See the view to know how to pass the access_token to Bime
  end
end