class FutureTweetsController < InheritedResources::Base
  before_filter :authenticate_client!
  before_action :require_twitter_connection
  respond_to :html, :xml, :json, :js
  def permitted_params
  params.permit!
 end

  def create
    create! do |format|
      if @future_tweet.post_at > Time.now
        TwitterManager.delay(:run_at=> @future_tweet.post_at,:queue => 'auto_x').future_tweet(@future_tweet.id,current_client)
        format.js  {render :js=>"$.notify('Scheduled tweet created', 'success');$('#myModal2').modal('hide');"}
      else
        TwitterManager.future_tweet(@future_tweet.id,current_client)
        format.js  {render :js=>"$.notify('Tweet posted', 'success');$('#myModal2').modal('hide')"}
      end
      puts "==========Future tweet scheduled==========="
      
    end
  end
end
