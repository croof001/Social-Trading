class FutureTweetsController < InheritedResources::Base
  before_filter :authenticate_client!
  
  def permitted_params
  params.permit!
 end

  def create
    create! do 
      TwitterManager.delay(:run_at=> @future_tweet.post_at,:queue => 'keyword_fetch').future_tweet(@future_tweet.id,current_client)
      puts "==========Future tweet scheduled==========="
    end
  end
end
