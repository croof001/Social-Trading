class FacebookManager
  
  
  def self.reply_to_stream(stream,post)
    
  end
  
  
  def self.publish(item)
    if item.post_at.to_i > Time.zone.now.to_i
      puts "Out of schedule"
      return 
    end
    
    account = item.account
    if account || account = Account.where(:client=>item.client,:account_type=>'fb',:primary=>true,:active=>true).first
      me = FbGraph::User.me(account.cred2)
      data = {}
      data[:message]=item.content
      if item.post && item.post.title
       #:picture => 'https://graph.facebook.com/matake/picture',
       data[:link] =item.post.published_url
       data[:name]= item.post.title
       #:description => 'A Ruby wrapper for Facebook Graph API'
      end
       
      post = me.feed!(data)
      item.remote_id=post.identifier
      item.posted = true
      item.save
    end
  end
  
  def self.get_streams(client)
    client.accounts.where(active:true,account_type:'fb').each do |account|
      user = FbGraph::User.me(account.cred2)
      user.accounts.each do |page|
        puts "=========================================="
        page.feed(:limit=>20).each do |feed|
          stream = Stream.new(account:account,posted_at:feed.created_time,stream_type:'fb_page_post',
                               remote_url:if feed.actions.first then feed.actions.first.link else nil end,
                               from_id:feed.from.identifier,
                               remote_id:feed.identifier,content:feed.message || feed.name || feed.caption ||feed.description)
          stream.save
          
        end
      end
    end
  end
  
end