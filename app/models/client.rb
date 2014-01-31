class Client < ActiveRecord::Base
  
  has_many :tweets
  has_many :keywords
  def name
    return first_name + " " + last_name
  end
end
