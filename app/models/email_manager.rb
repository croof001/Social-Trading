class EmailManager
  
  def self.send_notifications(keyword)
    case keyword.notification_frequency
    when '1','3','6','12','24','48'
      feeds = Tweet.where("created_at >= ?", keyword.notification_frequency.to_i.hours.ago)
      FeedNotifier.notify(keyword,feeds).deliver
    when 'hourly'
      feeds = Tweet.where("created_at >= ?",1.hour.ago)
      FeedNotifier..notify(keyword,feeds).deliver
    end
  end
  
  
  def self.notify_all()
    hour = Time.zone.now.hour
    Keyword.where(email_notification:true).each do |keyword|
      if interval=keyword.notification_frequency.to_i
   
        if  ((hour - 7)%interval)==0
                
          EmailManager.delay(:queue=>'notifications').send_notifications(keyword)
        end
      end
    end
    "Noticication scheduled"
  end
  
end