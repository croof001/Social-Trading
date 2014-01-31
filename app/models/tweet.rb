class Tweet < ActiveRecord::Base
  belongs_to :client
  belongs_to :keyword
  

 
end
