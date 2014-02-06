class TwitterManager
  def self.tweet(message,client)
    twitter_client(client).update(message)
  end
  
  def self.future_tweet(future_tweet_id,client)
    if FutureTweet.exists?(:id=>future_tweet_id)
      twitter_client(client).update(FutureTweet.find(future_tweet_id).message)
    end
  end
  
  def self.follow(user,client)
    twitter_client(client).follow(user)
  end
  
  def self.retweet(tweet,client)
    twitter_client(client).retweet(tweet)
  end
  
  def self.fetch_with_keyword(client, keyword)
    puts "quied #{keyword}"
    twitter_client(client).search("#{keyword.phrase}", :result_type => "recent").take(10).collect do |tweet|
        if not  Tweet.exists?(:twitter_uuid=>tweet.id) 
          Tweet.new(:message => tweet.text.dup.encode("UTF-8", "ISO-8859-1"), :author => tweet.user.screen_name, :twitter_uuid=>tweet.id, :client=>client,:keyword=>keyword).save
        end
    end
  end
  
  def self.fetch_all()
    puts "fetch all being run.."
    Client.all.each do |client|
      client.keywords.each do |keyword|
        TwitterManager.delay(:queue => 'keyword_fetch').fetch_with_keyword(client, keyword)
        end
      end
  end
  
  
  def self.twitter_client(client)
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