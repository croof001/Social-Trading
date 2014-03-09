class FeedNotifier < ActionMailer::Base
  default from: "notify@blueotter.yubi.in"
  
  def notify(keyword,feeds)
    @keyword = keyword
    @feeds   = feeds
    email_with_name = "#{keyword.client.name} <#{keyword.client.email}>"
    mail(to: email_with_name, subject: "New feeds for target #{keyword.nickname}")
  end
  
end
