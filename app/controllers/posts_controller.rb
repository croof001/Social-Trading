class PostsController < ApplicationController
  before_action :authenticate_client!
  def new
    @post = Post.new()
  end
  
  def create
    puts "====================="
    puts params.to_json
    puts "====================="
    @post = Post.new(post_params)
    if @post.account.client == current_client
     @post.client = current_client
     @post.save
     create_children
     @post.publish
     respond_to do |format|
       format.html{redirect_to new_post_path ,notice:'Post created successfully'}
       format.js {render :js=>"$.notify('Post created', 'success');$('form').reset();"}
       format.json{render :json=>{message:'Your post has been pusblished successfully'}.to_json}
     end
    else
    redirect_to root_path, notice:'Access violation'
    end
  end
  
  
  def post_params(hash=nil)
    params.require(:post).permit(:title,:content,:account_id,:content_type,:parent_id,:children,:post_at)
  end
  
  def create_children
    child_params.each do |index,child|
      if child[:id] && (Post.where(id:child[:id],client:current_client,post:@post).exists? == false)
        next
      else
        @child = Post.new(child)
        @child.post = @post
        @child.client = current_client
        @child.save  
      end
    end
  end
  
  def child_params
    if params[:children] then params[:children].permit! else {} end
  end
end
