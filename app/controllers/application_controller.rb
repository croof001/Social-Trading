class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def require_twitter_connection
    if current_client.present?
      if current_client.screen_name.to_s.empty?
        flash[:alert]= "You need to connect your twitter account first!!"
        redirect_to current_client
      end
        
    end
  end
end
