class Post < ActiveRecord::Base
  belongs_to :account
  belongs_to :client
  has_many :posts ,:foreign_key=>:parent_id
  belongs_to :post ,:foreign_key=>:parent_id
  
  
  def publish_children
    posts.each do |p|
      p.content["http://short.url"]=self.published_url
      p.save
      p.publish
    end
  end
  
  def publish
   unless self.posted == true
    if content_type == 'wp'
      WordpressManager.publish(self)
    elsif content_type== 'ttr'
      TwitterManager.publish(self)
    elsif content_type =='fb'
      FacebookManager.publish(self)
    end
    publish_children
   end
  end
  
end
