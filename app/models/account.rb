class Account < ActiveRecord::Base
  belongs_to :client
  
  def validate_cred
    if account_type=='wp'
      self.active = WordpressManager.validate_account(self)
    else
       true
    end
  end
  
  def easy_name
    if self.primary
      self.name
    else
      "#{self.name} #{self.username}"
    end
  end
  
end
