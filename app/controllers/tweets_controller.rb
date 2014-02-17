class TweetsController < ApplicationController
    before_filter :authenticate_client!
    before_action :require_twitter_connection
    before_action :set_keyword, only: [:show, :edit, :update, :destroy]

  # GET /keywords
  # GET /keywords.json
  def index
    clean_select_multiple_params
    @filterrific = Filterrific.new(
      Tweet,
      params[:filterrific] || session[:filterrific_tweets]
    )
  
    @tweets = Tweet.includes(:keyword).where(:client=>current_client).filterrific_find(@filterrific).page(params[:page])
    @gtweets = @tweets.group_by {|t| t.keyword}
    session[:filterrific_students] = @filterrific.to_hash
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def reset_filterrific
    # Clear session persistence
    session[:filterrific_students] = nil
    # Redirect back to the index action for default filter settings.
    redirect_to :action => :index
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
    if params[:keyword_id]
     keyword = Keyword.find(params[:keyword_id])
     unless keyword.client == current_client
       respond_to do |format|
         format.html { redirect_to tweets_url, :status => :forbidden, notice: 'Unauthized.' }
         format.json  {render json: {:error=>"forbidden"},:status=> :forbidden }
       end
       return
     end
     TwitterManager.delay(:queue => 'keyword_fetch').fetch_with_keyword(current_client, keyword)
    else
      current_client.keywords.each do |keyword|
        TwitterManager.delay(:queue => 'keyword_fetch').fetch_with_keyword(current_client, keyword)
      end
    end
    
    respond_to do |format|
        format.html { redirect_to tweets_url, notice: 'A tweet fecth has been scheduled.' }
        format.json { render action: 'show', status: :created}
      end
    
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
       format.js  {render :js=>"$.notify('Tweet deleted', 'success');removeTweet(#{@tweet.id})"}
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


    
   def clean_select_multiple_params hash = params
    hash.each do |k, v|
     case v
      when Array then v.reject!(&:blank?)
      when Hash then clean_select_multiple_params(v)
     end
    end
   end
    
end
