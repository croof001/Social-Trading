class FacebookManager
  def self.publish(item)
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
    client.accounts.where(active:true,account_type:'ttr').each do |account|
      
    end
  end
  
end