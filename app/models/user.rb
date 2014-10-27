class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  
  attr_accessor :password
  before_save :encrypt_password
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  
def create_named_user(access_token,group)
  begin
    user_response = access_token.post("/v3/named_users") do |r|
      r.params[:login] = self.email
      r.params[:external_id] = self.id
      r.params[:named_user_group_id] = group["id"]
    end
    user = JSON.parse(user_response.body)["result"]
  rescue Exception => e
  end
end

  def get_named_user(access_token)
    begin
      user_response = access_token.get("/v3/named_users/#{self.id}?external=true") #we want to see if the user id of the curent user exist in Bime
      user = JSON.parse(user_response.body)["result"]
      user
    rescue Exception => e
    end
  end


  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
