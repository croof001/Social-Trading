class Tweet < ActiveRecord::Base
  belongs_to :client
  belongs_to :keyword
  

  def self.fetch_with_keyword(client, keyword)
    puts "*************************************************"
    puts "Background task being run"
    twitter = Twitter::REST::Client.new do |config|
      config.consumer_key        = "rUqzjv3fCnAH5grduFxoUA"
      config.consumer_secret     = "irzIyOrjU1ArY0hbGHQ4cBrxtggbnoSghZlwo9Co"
    end
    twitter.search("#{keyword.phrase}", :result_type => "recent").take(10).collect do |tweet|
        Tweet.new(:message => tweet.text, :author => tweet.user.screen_name, :twitter_uuid=>tweet.id, :client=>client,:keyword=>keyword).save
    end
  end
  
end
