class DashboardsController < ApplicationController

  require 'oauth2'

  def index
    redirect_to bime_client.auth_code.authorize_url(:redirect_uri => "http://localhost:3001/dashboards/list")
  end

  def list
    if(params[:code])
      access_token = bime_client.auth_code.get_token(params[:code], :redirect_uri => "http://localhost:3001/dashboards/list")
      @client.site = "http://api.example.com:3000"
      resp = access_token.get('/v2/dashboards')
      @dashboards = JSON.parse(resp.body)["result"]
      resp = access_token.get('/v2/named_user_groups/1?name=WAC')
      @group = JSON.parse(resp.body)["result"]

      @bime_user = current_user.get_named_user(access_token)
      @bime_user = current_user.create_named_user(access_token,@group) if @bime_user.nil?
      resp = access_token.get('/v2/named_user_groups/' + @bime_user["named_user_group_id"].to_s)
      @group = JSON.parse(resp.body)["result"]
      p @group
    end
  end

  def show

  end

  private
  def bime_client
    @client ||= OAuth2::Client.new('gaClfxkgyRzfsdykDWONpyVFOE73JxzijZbYJHn9', 'rRf0ktbFFSoYizdH8fMNgfpwKAZFrI2gQTOgi5Ed',
                                   :site => 'http://toto3.example.com:3000/',
                                   :request_token_path => "/oauth/request_token",
                                   :access_token_path  => "/oauth/access_token",
                                   :authorize_path     => "/oauth/authorize",
                                   :parse_json => true
    )
  end
end