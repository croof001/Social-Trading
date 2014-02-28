class Stream < ActiveRecord::Base
  belongs_to :post
  belongs_to :account
end
