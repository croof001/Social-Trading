class Keyword < ActiveRecord::Base
  belongs_to :client
  has_many :tweets
end
