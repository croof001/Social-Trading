class TwitterManager
  def self.tweet(message,client,account=nil)
    twitter_client(client,account).update(message)
  end
  
  def self.future_tweet(future_tweet_id,client)
    if FutureTweet.exists?(:id=>future_tweet_id)
      twitter_client(client).update(FutureTweet.find(future_tweet_id).message)
    end
  end
  
  def self.follow(user,client,account=nil)
    twitter_client(client,account).follow(user)
  end
  
  def self.retweet(tweet,client,account=nil)
    twitter_client(client,account).retweet(tweet)
  end
  
  def self.fetch_with_keyword(client, keyword,auto=false)
    puts "quied #{keyword.phrase}"
    
    query_options = Hash.new
    query_options[:result_type]  = "recent"
    query_options[:geocode]="#{keyword.lattitude},#{keyword.longitude},#{keyword.radius}mi" if keyword.geocoded
    query_options[:lang]="#{keyword.language}" if not keyword.language.to_s.empty?
    query_options[:since_id]= "#{keyword.last_tweet}" if not keyword.last_tweet.to_s.empty?
    query_options[:max_count]= "#{keyword.max_count}" if keyword.max_count

    
    require 'pp'
    pp query_options
    results=twitter_client(client).search("#{keyword.phrase}",query_options ).take(50)
    if results.first
      keyword.last_tweet = results.first.id
    end
    puts "=============================="
    puts results.count
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
  
  
  def self.twitter_client(client,account = nil)
    tclient = Twitter::REST::Client.new do |config|
     config.consumer_key       = "rUqzjv3fCnAH5grduFxoUA"
     config.consumer_secret    = "irzIyOrjU1ArY0hbGHQ4cBrxtggbnoSghZlwo9Co"
     if account || account = Account.where(:client=>client,:account_type=>'ttr',:primary=>true,:active=>true).first
       config.oauth_token        = account.cred1
       config.oauth_token_secret = account.cred2       
     end
     end
     return tclient
  end 
  
  
  def self.stream_client(client,account=nil)
      tclient = Twitter::Streaming::Client.new  do |config|
     config.consumer_key       = "rUqzjv3fCnAH5grduFxoUA"
     config.consumer_secret    = "irzIyOrjU1ArY0hbGHQ4cBrxtggbnoSghZlwo9Co"
     if account || account = Account.where(:client=>client,:account_type=>'ttr',:primary=>true,:active=>true).first
       config.oauth_token        = account.cred1
       config.oauth_token_secret = account.cred2       
     end
     end
     return tclient
 end
  
  #public interfaces-------------------------------------
  def self.publish(item)
    t = tweet(item.content,item.client,item.account)
    item.remote_id = t.id
    item.published_url = t.url.to_s
    item.save
  end
  
  def self.get_streams(client)
    
    client.accounts.where(active:true,account_type:'ttr').each do |account|
      options={}
      since = Stream.where(account:account,stream_type:'ttr_mention').order("posted_at asc").last
      if since
        puts "Since ID found"
      else
        puts "No Since ID found"
      end
      options[:since_id] = since.remote_id if since
      
      twitter_client(nil,account).mentions_timeline(options).each do |tweet|
        stream = Stream.new(content:tweet.text,posted_at:tweet.created_at,remote_id:tweet.id,
                            remote_url:tweet.url.to_s,stream_type:'ttr_mention',account:account)
        stream.save
        
      end
    end
  end
  
end