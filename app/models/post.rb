class Post < ActiveRecord::Base
  belongs_to :account
  belongs_to :client
  
  
  def publish_now
    if account.terminal == 'wordpress'
      
    end
  end
  

end
