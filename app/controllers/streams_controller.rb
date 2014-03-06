class StreamsController < InheritedResources::Base
  before_action :authenticate_client!
  def reply
    @stream = Stream.find(params[:id])
    if @stream.account.client == current_client
      content = params[:contnet]
      @post = Post.new(client:current_client, account:@stream.account, content_type:'stream_reply',
                       content:content,post_at:params[:post_at],is_draft:false)
      @post.save
      
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
