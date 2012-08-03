class AdminController < ApplicationController

  def setup
    access_token = OAuth2::AccessToken.new(bime_client,"VeJOmS8JjmjcIqRXHlXrrtGsIhmPK6gV46HMMx43")
    @client.site = "http://api.example.com:3000"
    begin
      group_response = access_token.post("/v2/named_user_groups") do |r|
        r.params[:name] = "Awesome Group"
      end
      group = JSON.parse(group_response.body)["result"]

      security_rule_response = access_token.post("/v2/data_security_rules") do |r|
        r.params["connection_id"] = 1
        r.params["datafield"] = "Ship Mode"
        r.params["authorized_values"] = ["Regular Air"]
      end

      rule = JSON.parse(security_rule_response.body)["result"]

      security_subscription_resp = access_token.post("/v2/named_user_group_securities") do |r|
        r.params["named_user_group_id"] = group["id"]
        r.params["data_security_rule_id"] = rule["id"]
      end

      dash_subscription_resp = access_token.post("/v2/dashboard_subscriptions") do |r|
        r.params["named_user_group_id"] = group["id"]
        r.params["dashboard_id"] = 1
      end

    rescue Exception => e
      p e.message
    end

    redirect_to "/log_in", :notice => "Setup complete"

  end

end
