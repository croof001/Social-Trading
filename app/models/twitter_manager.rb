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
  
  def self.fetch_with_keyword(client, keyword,auto=false)
    puts "quied #{keyword.phrase}"
    
    query_options = Hash.new
    query_options[:result_type]  = "recent"
    query_options[:geocode]="#{keyword.lattitude},#{keyword.longitude},#{keyword.radius}mi" if keyword.geocoded
    query_options[:lang]="#{keyword.language}" if not keyword.language.to_s.empty?
    query_options[:since_id]= "#{keyword.last_tweet}" if not keyword.last_tweet.to_s.empty?
    query_options[:max_count]= "#{keyword.max_count}" if keyword.max_count

    
    
    results=twitter_client(client).search("#{keyword.phrase}",query_options ).take(50)
    if results.first
      keyword.last_tweet = results.first.id
    end
    results.each do |tweet|
        if not  Tweet.exists?(:twitter_uuid=>tweet.id) 
          new_post=Tweet.new(:message => tweet.text.dup.encode("UTF-8", "ISO-8859-1"), :author => tweet.user.screen_name, :twitter_uuid=>tweet.id, :client=>client,:keyword=>keyword)
          new_post.save
          if auto
            if keyword.should_auto_follow?
              TwitterManager.delay(:queue => 'auto_x').follow(new_post.author,client)
              keyword.follow_yet = keyword.follow_yet + 1
               puts "+++++++++++++++autofollow requested+++++++++++++++++++"
            end
            if keyword.should_auto_retweet? 
              puts "+++++++++++++++autoretweet requested+++++++++++++++++++"
              TwitterManager.delay(:queue => 'auto_x').retweet(new_post.twitter_uuid,client)
              keyword.tweets_yet = keyword.tweets_yet + 1
            end
            if keyword.should_auto_reply?
              keyword.reply_yet = keyword.reply_yet + 1
              puts "+++++++++++++++autoreply requested+++++++++++++++++++"
            end
            keyword.save #save changes to auto_actions count
          end
          
        end
    end
  end
  
  def self.fetch_all(auto=false)
    puts "fetch all being run.."
    Client.all.each do |client|
      client.keywords.each do |keyword|
        if keyword.should_fetch?
          TwitterManager.delay(:queue => 'keyword_fetch').fetch_with_keyword(client, keyword,auto)
        end
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