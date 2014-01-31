ActiveAdmin.register Client do

  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
  
  controller do
    #...
    def permitted_params
      params.permit!
    end
  end
  
  member_action :fetch_tweets ,:method => :get do 
    
  twitter = Twitter::REST::Client.new do |config|
    config.consumer_key        = "rUqzjv3fCnAH5grduFxoUA"
    config.consumer_secret     = "irzIyOrjU1ArY0hbGHQ4cBrxtggbnoSghZlwo9Co"
  end
  
  @client = Client.find(params[:id])
   @client.keywords.each do |keyword|
      twitter.search("#{keyword.phrase}", :result_type => "recent").take(10).collect do |tweet|
        Tweet.new(:message => tweet.text, :author => tweet.user.screen_name, :client=>@client).save
      end
    end
    redirect  admin_clients_tweets_url(@client)
  end
  
  
end
