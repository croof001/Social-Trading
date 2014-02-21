class TwitterAccessController < ApplicationController
    before_filter :authenticate_client!
  

  

  
  def follow
    tweeter = params[:tweeter]
    TwitterManager.follow(tweeter,current_client)
    respond_to do |format|
    format.html {redirect_to tweets_url, notice: "You are now following #{tweeter}"}
    format.js {render :js =>"$.notify('You are now following #{tweeter}', 'success')"}
    end
  end
  
  def retweet
    tweet = params[:tweet_id]
    TwitterManager.retweet(tweet,current_client)
    respond_to do |format|
       format.html{ redirect_to tweets_url, notice: "Retweet successful"}
       format.js {render :js =>"$.notify('Retweet successful', 'success')"}
    end
  end
 
 
 
end
