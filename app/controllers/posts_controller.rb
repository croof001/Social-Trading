class PostsController < ApplicationController
  before_action :authenticate_client!
  def new
    @scheduled_posts = Post.where("post_at >= ?",Time.zone.now).where.not(:posted=>true).where(:parent_id=>nil).order("updated_at desc")
    @published_posts = Post.where(posted:true).where(:parent_id=>nil).order("updated_at desc")
    @draft_posts     = Post.where(is_draft:true).where(:parent_id=>nil).order("updated_at desc")
    @posts=[]
    @accounts = current_client.accounts.order("account_type desc").where(:active=>true)
    @accounts.each do |account|
      @posts.push(Post.new(:account=>account))
    end 
    
  end
  
  def edit
    post = Post.find(params[:id])
    @scheduled_posts = Post.where("post_at >= ?",Time.zone.now).where.not(:posted=>true).where(:parent_id=>nil)
    @published_posts = Post.where(posted:true).where(:parent_id=>nil)
    @draft_posts     = Post.where(is_draft:true).where(:parent_id=>nil)
    @posts=[post]
    @accounts = current_client.accounts.order("account_type desc").where(:active=>true)
    @accounts.each do |account|
      @posts.push(Post.new(:account=>account)) if account!=post.account
    end 
    
    render 'new'
  end
  
  
  def create
    @post = Post.new(post_params)
    if @post.account.client == current_client
     @post.client = current_client
     
     create_children
     if params[:commit]=='publish' || params[:commit]=='Publish'
       @post.is_draft=false
       @post.save
       @post.publish
       respond_to do |format|
         format.html{redirect_to new_post_path ,notice:'Post created successfully'}
         format.js {render :js=>"$.notify('Post created successfully', 'success');$('#myModal2').modal('hide');"}
         format.json{render :json=>{message:'Your post has been pusblished successfully'}.to_json}
       end
     else
       @post.is_draft=true
       @post.save
       respond_to do |format|
         format.html{redirect_to new_post_path ,notice:'Draft saved successfully'}
         format.js {render :js=>"$.notify('Draft saved', 'success');"}
         format.json{render :json=>{message:'Your post has been saved into drafts'}.to_json}
       end
     end
    else
    redirect_to root_path, notice:'Access violation'
    end
  end
  
  def publish
    @post = Post.where(id:params[:post_id],client:current_client).first
    @post.post_at = Time.zone.now
    @post.publish
         respond_to do |format|
       format.html{redirect_to new_post_path ,notice:'Post created successfully'}
       format.js {render :js=>"$.notify('Post published', 'success');PubCallBack.rmp(#{@post.id});#{params[:callback]}"}
       format.json{render :json=>{message:'Your post has been pusblished successfully'}.to_json}
     end
  end
  
  def destroy
    @post = Post.find(params[:id])
    if @post.client == current_client
       Post.where(post:@post).delete_all #Deleting child objects
       @post.destroy
     respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
      format.js  {render :js=>"$.notify('Post Deleted', 'success');pub_remove_post(#{@post.id});#{params[:callback]}" }
     end
    end
  end
  

  
 def update
    @post = Post.find(params[:id])
    if @post.client == current_client
      Post.where(post:@post).delete_all #@post.posts.delete_all doesn't seems to work
      create_children
      if params[:commit]=='publish'
        @post.is_draft=false
        @post.update(post_params)
        @post.publish
        respond_to do |format|
          format.html{redirect_to new_post_path ,notice:'Post updated successfully'}
          format.js {render :js=>"$.notify('Post modified', 'success');$('#myModal2').modal('hide');"}
          format.json{render :json=>{message:'Your post has been pusblished successfully'}.to_json}
        end
      else
        @post.is_draft=true
        @post.update(post_params)
        respond_to do |format|
          format.html{redirect_to new_post_path ,notice:'Draft saved successfully'}
          format.js {render :js=>"$.notify('Draft saved', 'success');"}
          format.json{render :json=>{message:'Your post has been saved into drafts'}.to_json}
        end
      end

    else
    render :text=>"abcd"
    end
  end
  
  private
  
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
