class Keyword < ActiveRecord::Base
  belongs_to :client
  has_many :tweets, :dependent => :delete_all
  
  def self.options_for_keyword_type
  [
    ['Containing given words', 'phrase'],
    ['Containing given hashtag', 'hashtag'],
    ['Reply to you', 'replay'],
    ['Mentioning someone', 'mention'],
    ['Advanced', 'advanced']
  ]
  end
  
  def self.options_for_priority
    [
    ['Lead', 1],
    ['Build followers', 2],
    ['Research', 3],
    ['Competition', 4]
    ] +
    (5..20).collect {|i| ["Others #{i}",i]}
    
  end
  
  def self.options_for_notification_frequency
    [
    ['Every hour', 1],
    ['Every 3 hours', 3],
    ['Every 6 hours', 6],
    ['Twice a day', 12],
    ['Once per day',24],
    ['Every other day',48]
    ] 
  end
  
  def should_auto_follow?
    puts "At start"
    unless auto_follow
      print "disabled"
      return false
    end

    if @probability_f.nil?
      @probability_f = [true,true]
    end
    
    now = Time.now.seconds_since_midnight
    if  now < auto_follow_time_from || now > auto_follow_time_to
      puts "Outside auto_follow period"
      follow_yet = 0
      return false #We are outside auto_action interval
    end
    
    seconds_left = auto_follow_time_to - now
    puts "#{seconds_left} seconds left in auto_follow period"
    fetch_interval = (3600 * 24) / fetch_frequency
    puts "fecth occurs at every #{fetch_interval} seonds "
    fetches_left = seconds_left/fetch_interval
    puts "#{fetches_left} fetches left"
    follows_left = auto_follow_rate - follow_yet
    puts "#{follows_left} follows left"
    
    if follows_left <1 #We have exceeded auto_action limit of the days
      puts "No follows left for the period"
      return false
    elsif follows_left > fetches_left #We have too many follows left
      puts "A lot of follows left"
      choice = @probability_f.sample
      @probability_f.push false
      return choice
    else
      puts "Let us choose randomly"
      return [true, false].sample
    end
    
  end
  
  
  
  def should_auto_retweet?
    unless auto_retweet
      return false
    end
    if @probability_t.nil?
      @probability_t = [true,true]
    end
    now = Time.now.seconds_since_midnight
    if  now < auto_retweet_time_from || now > auto_retweet_time_to
      tweets_yet = 0
      return false #We are outside auto_action interval
    end
    seconds_left = auto_retweet_time_to - now
    fetch_interval = (3600 * 24) / fetch_frequency
    fetches_left = seconds_left/fetch_interval
    tweets_left = auto_retweet_rate - tweets_yet
    if tweets_left <1 #We have exceeded auto_action limit of the days
      return false
    elsif tweets_left > fetches_left #We have too many follows left
      choice = @probability_t.sample
      @probability_t.push false
      return choice
    else
      return [true, false].sample
    end
    
  end
  

  def should_auto_reply?
    unless auto_reply
      return false
    end
    if @probability_r.nil?
      @probability_r = [true,true]
    end
    now = Time.now.seconds_since_midnight
    if  now < auto_reply_time_from || now > auto_reply_time_to
      reply_yet  = 0
      return false #We are outside auto_action interval
    end
    
    seconds_left = auto_reply_time_to - now
    fetch_interval = (3600 * 24) / fetch_frequency
    fetches_left = seconds_left/fetch_interval
    reply_left = auto_reply_rate - reply_yet
    if reply_left <1 #We have exceeded auto_action limit of the days
      return false
    elsif reply_left > fetches_left #We have too many follows left
      choice = @probability_r.sample
      @probability_r.push false
      return choice
    else
      return [true, false].sample
    end
    
  end
  
    
  
  
end
