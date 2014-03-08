class StreamsController < InheritedResources::Base
  before_action :authenticate_client!
  
  def index
    @streams = Stream.where(stream_type:['ttr_mention','fb_page_post']).page(params[:response_page]).per(5)
    @action_streams = Stream.where(stream_type:['ttr_usertimeline']).page(params[:actions_page]).per(5)
  end
  
  
  def reply
    @stream = Stream.find(params[:id])
    if @stream.account.client == current_client
      content = params[:content]
      @post = Post.new(client:current_client, account:@stream.account, content_type:'stream_reply',
                       content:content,post_at:params[:post_at],is_draft:false)
      @post.save
      
      if @stream.stream_type=='ttr_mention'
        TwitterManager.reply_to_stream(@stream,@post)
      end
      
      respond_to do |format|
        format.json {render :json=>@post.to_json}
        format.js {render :js=>"$.notify('Reply successful', 'success');"}
      end
    end
  end
  
  def follow
    @stream = Stream.find(params[:id])
    respond_to do |format|
        format.json {render :json=>@post.to_json}
        format.js {render :js=>"$.notify('Follow successful', 'success');"}
      end
    
  end
  
  def destroy
    destroy! do |format|
      format.js {render :js=>"$.notify('Stream feed deleted successfully', 'success');streamRemovefeed(#{@stream.id});"}
    end
  end
  
end
