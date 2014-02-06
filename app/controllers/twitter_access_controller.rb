class TwitterAccessController < ApplicationController
    before_filter :authenticate_client!
  
  def generate_twitter_oauth_url
   oauth_callback = "http://#{request.host}:#{request.port}/oauth_account"
   @consumer = OAuth::Consumer.new("rUqzjv3fCnAH5grduFxoUA","irzIyOrjU1ArY0hbGHQ4cBrxtggbnoSghZlwo9Co", :site => "https://api.twitter.com")
 
   @request_token = @consumer.get_request_token(:oauth_callback => oauth_callback)
   session[:request_token] = @request_token
 
   redirect_to @request_token.authorize_url(:oauth_callback => oauth_callback)
  end
  
  def oauth_account
   unless params[:denied]
     if TwitterOauthSetting.find_by_client_id(current_client.id).nil?
       @request_token = session[:request_token]
       @access_token = @request_token.get_access_token(:oauth_verifier => params["oauth_verifier"])
       TwitterOauthSetting.create(atocken: @access_token.token, secret: @access_token.secret, client_id: current_client.id)
       update_user_account()
     end
   redirect_to client_url(current_client), notice: "Your Twitter account is now connected"
   else
     redirect_to root_url ,notice: "You haven't authorized us to access your Twitter account."
   end
  end
  
  def disconnect_twitter
    TwitterOauthSetting.find_by_client_id(current_client.id).delete
    clear_user_account
    redirect_to client_url(current_client), notice: "Twitter account disconnected"
  end
  
  def follow
    tweeter = params[:tweeter]
    TwitterManager.follow(tweeter,current_client)
    redirect_to tweets_url, notice: "You are now following #{tweeter}"
  end
  
  def retweet
    tweet = params[:tweet_id]
    TwitterManager.retweet(tweet,current_client)
    redirect_to tweets_url, notice: "Retweet successful"
  end
 
  private
    
    def update_user_account
      user_twitter_profile = TwitterManager.twitter_client(current_client).user
      current_client.update_attributes({
      name_on_twitter: user_twitter_profile.name,
      screen_name: user_twitter_profile.screen_name,
      url: user_twitter_profile.url.to_s,
      profile_image_url: user_twitter_profile.profile_image_url.to_s,
      location: user_twitter_profile.location,
      description: user_twitter_profile.description
   })
    end
    
    def clear_user_account
      current_client.update_attributes({
      name_on_twitter: nil,
      screen_name: nil,
      url: nil,
      profile_image_url: nil,
      location: nil,
      description: nil})
    end
    
    def get_client
    tclient = Twitter::REST::Client.new do |config|
     config.consumer_key       = "rUqzjv3fCnAH5grduFxoUA"
     config.consumer_secret    = "irzIyOrjU1ArY0hbGHQ4cBrxtggbnoSghZlwo9Co"
     config.oauth_token        = TwitterOauthSetting.find_by_client_id(current_client.id).atocken
     config.oauth_token_secret = TwitterOauthSetting.find_by_client_id(current_client.id).secret
    end  
  end
 
end
