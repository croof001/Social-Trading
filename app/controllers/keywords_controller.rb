class KeywordsController < ApplicationController
  before_filter :authenticate_client!
  before_action :set_keyword, only: [:show, :edit, :update, :destroy]
  
  # GET /keywords
  # GET /keywords.json
  def index
    @keywords = Keyword.where(:client=>current_client)
  end

  # GET /keywords/1
  # GET /keywords/1.json
  def show
    unless @keyword.client == current_client  
       respond_to do |format|
       format.html { redirect_to keywords_url, :status => :forbidden, notice: 'Unauthized.' }
       format.json  {render json: {:error=>"forbidden"},:status=> :forbidden }
      end
    end
  end

  # GET /keywords/new
  def new
    @keyword = Keyword.new
  end

  # GET /keywords/1/edit
  def edit
   unless @keyword.client == current_client  
       respond_to do |format|
       format.html { redirect_to keywords_url, :status => :forbidden, notice: 'Unauthized.' }
       format.json  {render json: {:error=>"forbidden"},:status=> :forbidden }
      end
    end
  end

  # POST /keywords
  # POST /keywords.json
  def create
    @keyword = Keyword.new(keyword_params)
    @keyword.client = current_client
    respond_to do |format|
      if @keyword.save
        format.html { redirect_to @keyword, notice: 'Keyword was successfully created.' }
        format.json { render action: 'show', status: :created, location: @keyword }
        format.js {
          flash[:notice]="Keyword created successfully"
          render :js=>"$.notify('Keyword created', 'success');window.location.href='#{keywords_url}';"}
      else
        format.html { render action: 'new' }
        format.json { render json: @keyword.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /keywords/1
  # PATCH/PUT /keywords/1.json
  def update
    if @keyword.client == current_client
      
      respond_to do |format|
        if @keyword.update(keyword_params)
          format.html { redirect_to @keyword, notice: 'Keyword was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @keyword.errors, status: :unprocessable_entity }
        end
      end
      
    else
     respond_to do |format|
       format.html { redirect_to keywords_url, :status => :forbidden, notice: 'Unauthized.' }
       format.json  {render json: {:error=>"forbidden"},:status=> :forbidden }
      end
    end
  end

  # DELETE /keywords/1
  # DELETE /keywords/1.json
  def destroy
    if @keyword.client == current_client
     @keyword.destroy
     respond_to do |format|
       format.html { redirect_to keywords_url }
       format.json { head :no_content }
      end
    else
       respond_to do |format|
       format.html { redirect_to keywords_url, :status => :forbidden, notice: 'Unauthized.' }
       format.json  {render json: {:error=>"forbidden"},:status=> :forbidden }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_keyword
      @keyword = Keyword.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def keyword_params
            params.require(:keyword).permit(:phrase, :priority, :client_id, :auto_reply,
                                             :auto_retweet,:auto_follow,:default_reply,:longitude,
                                             :lattitude,:radius,:color,:notes,:geocoded,
                                             :language, :auto_follow_time_from, :auto_follow_time_to,
                                             :auto_follow_rate, :auto_retweet_time_to,:auto_retweet_time_from,
                                             :auto_retweet_rate,
                                             :auto_reply_time_from, :auto_reply_time_to,:auto_reply_rate, :nickname,
                                             :email_notification, :notification_frequency,
                                             :fetch_frequency, :max_count)
    end
end
