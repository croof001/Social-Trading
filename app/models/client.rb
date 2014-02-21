class Client < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :tweets
  has_many :keywords
  has_many  :accounts
  def name
    first_name="" unless first_name 
    return first_name + " " + last_name.to_s
  end
end
