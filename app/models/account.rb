class Account < ActiveRecord::Base
  belongs_to :client
  
  def validate_cred
    if account_type=='wp'
      self.active = WordpressManager.validate_account(self)
    else
       true
    end
  end
end
