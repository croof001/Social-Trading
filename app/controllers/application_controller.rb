class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def require_twitter_connection
    if current_client.present?
      if not current_client.accounts.where(:primary=>true,:account_type=>'ttr').exists?
        flash[:alert]= "You need to connect your twitter account first!!"
        redirect_to current_client
      end
        
    end
  end
end
