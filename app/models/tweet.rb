class Tweet < ActiveRecord::Base
  belongs_to :client
  belongs_to :keyword
  

  def self.fetch_with_keyword(client, keyword)
    puts "quied #{keyword}"
    get_client(client).search("#{keyword.phrase}", :result_type => "recent").take(10).collect do |tweet|
        if not  Tweet.exists?(:twitter_uuid=>tweet.id) 
          Tweet.new(:message => tweet.text.dup.encode("UTF-8", "ISO-8859-1"), :author => tweet.user.screen_name, :twitter_uuid=>tweet.id, :client=>client,:keyword=>keyword).save
        end
    end
  end
  
  def self.fetch_all()
    puts "fetch all being run.."
    Client.all.each do |client|
      client.keywords.each do |keyword|
        Tweet.delay(:queue => 'keyword_fetch').fetch_with_keyword(client, keyword)
        end
      end
  end
  
  def self.get_client(client)
    tclient = Twitter::REST::Client.new do |config|
     config.consumer_key       = "rUqzjv3fCnAH5grduFxoUA"
     config.consumer_secret    = "irzIyOrjU1ArY0hbGHQ4cBrxtggbnoSghZlwo9Co"
     if TwitterOauthSetting.exists?(:client=>client)
       config.oauth_token        = TwitterOauthSetting.find_by_client_id(client.id).atocken
       config.oauth_token_secret = TwitterOauthSetting.find_by_client_id(client.id).secret
     end
     end
     return tclient
  end  
  
end
