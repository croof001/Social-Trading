class PostsController < ApplicationController
  def new
    @post = Post.new
  end
  
  def create
    post = Post.new(post_params)
    post.save
    if post.post_at > Time.now
      schedule_post(post)
    else
      publish_now(post)
    end  
    
  end
  
  
  def post_params
    
  end
  
  def control_params
    
  end
end
