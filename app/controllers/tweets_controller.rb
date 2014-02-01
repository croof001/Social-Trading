class TweetsController < ApplicationController
    before_action :set_keyword, only: [:show, :edit, :update, :destroy]

  # GET /keywords
  # GET /keywords.json
  def index
    @tweets  = Tweet.includes(:keyword).where(:client=>current_client)
    @gtweets = @tweets.group_by {|t| t.keyword}
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
     Tweet.delay(:queue => 'keyword_fetch').fetch_with_keyword(current_client, keyword)
    else
      current_client.keywords.each do |keyword|
        Tweet.delay(:queue => 'keyword_fetch').fetch_with_keyword(current_client, keyword)
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
    

    
end
