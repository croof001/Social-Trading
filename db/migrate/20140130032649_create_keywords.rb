class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string :phrase
      
      t.boolean :auto_follow, :default=>false
      t.integer    :auto_follow_time_from, :default=> 36000
      t.integer    :auto_follow_time_to , :default=> 61200
      t.integer :auto_follow_rate, :default=>1
      
      t.boolean :auto_retweet, :default=>false
      t.integer    :auto_retweet_time_from, :default=> 36000
      t.integer   :auto_retweet_time_to, :default=> 61200
      t.integer :auto_retweet_rate, :default=>1
      
      t.boolean :auto_reply, :default=>false
      t.integer    :auto_reply_time_from, :default=> 36000
      t.integer    :auto_reply_time_to, :default=> 61200
      t.integer :auto_reply_rate, :default=>1
      t.string  :default_reply
      
      t.boolean   :geocoded, :default=>false
      t.string    :lattitude, :length=>40
      t.string    :longitude, :length=>40
      t.float     :radius, :default=>300
      
      t.string :notes , :length =>256
      t.string :color ,:length=>12,:default=>'#AAAAAA'
      #t.string   :keyword_type, :length=>20
      t.string  :nickname, :length=>30
      t.integer :priority
      t.string :language, :length=>4
      t.integer :max_count, :default=>50
      t.boolean :email_notification, :default=>false
      t.integer  :fetch_frequency, :default=>72
      t.string   :notification_frequency ,:length=>'24',:default=>'hourly'
      
      t.references :client, index: true
      
      
      
      t.boolean :read, :default=>false
      t.string :created_by, :length=>20, :default=>'system' #who created the phrase
      
      #Fields used internally by the systemm
      t.string :last_tweet
      t.datetime :last_fetch
      t.datetime :last_follow
      t.datetime :last_retweet
      t.integer :tweets_yet, :default=>0
      t.integer :follow_yet, :default=>0
      t.integer :reply_yet, :default=>0
      t.datetime :last_retweet
      t.datetime :last_reply
      
      t.datetime :last_ai_training_at, :default=>Time.zone.now
      t.datetime :last_ai_rating_at, :default=>Time.zome.now
      t.string :ai_url
      t.timestamps
    end
  end
end
