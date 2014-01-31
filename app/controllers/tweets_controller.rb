class TweetsController < ApplicationController
    before_action :set_keyword, only: [:show, :edit, :update, :destroy]

  # GET /keywords
  # GET /keywords.json
  def index
    @tweets = Tweet.where(:client=>current_client)
  end

  # GET /keywords/1
  # GET /keywords/1.json
  def show
  end

  # GET /keywords/new
  def new
    @keyword = Keyword.new
  end

  # GET /keywords/1/edit
  def edit
  end

  # POST /keywords
  # POST /keywords.json
  def create
    keyword = Keyword.find(params[:keyword_id])
    fetch_tweets_for_keyword(keyword)
    redirect_to tweets_path
  end

  # PATCH/PUT /keywords/1
  # PATCH/PUT /keywords/1.json
  def update
    respond_to do |format|
      if @keyword.update(keyword_params)
        format.html { redirect_to @keyword, notice: 'Keyword was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @keyword.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /keywords/1
  # DELETE /keywords/1.json
  def destroy
    if @tweet.client == current_client
     @tweet.destroy
     respond_to do |format|
       format.html { redirect_to tweets_url }
       format.json { head :no_content }
      end
    else
       respond_to do |format|
       format.html { redirect_to tweets_url, :status => :forbidden, notice: 'Unauthized.' }
       format.json  {render json: {:error=>"forbidden"},:status=> :forbidden }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_keyword
      @tweet = Tweet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def keyword_params
      params.require(:keyword).permit(:phrase, :priority, :client_id)
    end
    
    def fetch_tweets_for_keyword(keyword)
      puts "*************************************************"
      puts "Background task being run"
      twitter = Twitter::REST::Client.new do |config|
      config.consumer_key        = "rUqzjv3fCnAH5grduFxoUA"
      config.consumer_secret     = "irzIyOrjU1ArY0hbGHQ4cBrxtggbnoSghZlwo9Co"
      end
      twitter.search("#{keyword.phrase}", :result_type => "recent").take(10).collect do |tweet|
        Tweet.new(:message => tweet.text, :author => tweet.user.screen_name, :client=>current_client,:keyword=>keyword).save
      end
    end
    handle_asynchronously :fetch_tweets_for_keyword
end
