class WordpressManager
  
  def self.wp_client(client,account=nil)
    if account || account=client.accounts.where(:account_type=>'wp',:active=>true,:primary=>true).first
      wp = Rubypress::Client.new(:host => account.cred3, :username => account.cred1, :password => account.cred2)
      return wp
    end
  end
  

  
  def self.post(data,client,account=nil)
    wp_client(client,account).newPost( :content => { :post_status => "publish", :post_date => (if data.post_at then data.post_at else Time.zone.now end), :post_content => data.content, :post_title => data.title }) 

  end
  

  
  #------------------------Common interface fundtions -----------------
  def self.publish(data)
    if data.post_at.to_i > Time.zone.now.to_i
      puts "Out of schedule"
      return 
    end
    
    data.remote_id = post(data,data.client,data.account)
      
    data.published_url=wp_client(data.client,data.account).getPost(:post_id=>data.remote_id,:fields=>[:link,:guid])["link"]

    data.posted = true
    data.save
  end
  
  def self.validate_account(account)
    raise "Not a wordpress account" if account.account_type != 'wp'
    begin 
      wp_client(nil,account).getOptions
      return true
    rescue
      account.active = false
      return false
    end
  end
  
  def self.publish_message(message,client=nil,account=nil)
    data= Post.new(content:message,client:client,account:account,title:'No title')
    publish(data)
  end
  
  def self.get_streams(client)
    
  end
  
  
end