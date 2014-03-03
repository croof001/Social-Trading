class Post < ActiveRecord::Base
  belongs_to :account
  belongs_to :client
  has_many :posts ,:foreign_key=>:parent_id , :dependent => :nullify
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
      unless self.post_at.to_i >Time.zone.now.to_i
        WordpressManager.publish(self)
      else
        WordpressManager.delay(:run_at=>self.post_at,:queue => 'auto_x').publish(self)
      end
    elsif content_type== 'ttr'
      unless self.post_at.to_i >Time.zone.now.to_i
        TwitterManager.publish(self)
      else
        TwitterManager.delay(:run_at=>self.post_at,:queue => 'auto_x').publish(self)
      end
    elsif content_type =='fb'
      unless self.post_at.to_i >Time.now.to_i
        FacebookManager.publish(self)
      else
        FacebookManager.delay(:run_at=>self.post_at,:queue => 'auto_x').publish(self)
      end
    end
    publish_children
   end
  end
  
end
