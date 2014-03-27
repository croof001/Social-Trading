require 'google/api_client'
class PredictionManager
  
  def self.generate_training_data(keyword)
     tdata = []
     
     feeds = Tweet.where(keyword:keyword).where("updated_at >= ?",keyword.last_ai_training_at).where.not(user_rating:nil)
     feeds.each do |feed|
       tdata.push({"output" => feed.user_rating, "csvInstance" => [feed.message]})
     end
     return tdata
  end
  
  def self.update_model(keyword)
    api_client = get_client
    prediction = api_client.discovered_api('prediction', 'v1.6')
    last_ai_training_at = Time.zone.now
    feeds = Tweet.where(keyword:keyword).where("updated_at >= ?",keyword.last_ai_training_at).where.not(user_rating:nil)
    feeds.each do |feed|
     api_client.execute(:api_method => prediction.trainedmodels.update,
                       parameters:{ 'id' => keyword.nickname.gsub(/[^[:alnum:]]/, ""), project:"929083618245"},
                       :body_object => { output: feed.user_rating, csvInstance: [feed.message ]
                        })
    end
    
    keyword.last_ai_training_at=last_ai_training_at
    keyword.save
  end
  
  def self.predict(feed)
     api_client = get_client
     prediction = api_client.discovered_api('prediction', 'v1.6')
     if feed.keyword.ai_url
              response   = api_client.execute(
              :api_method => prediction.trainedmodels.predict,
              parameters:{
              'id' => feed.keyword.nickname.gsub(/[^[:alnum:]]/, ""),
              project:"929083618245"},
              
              :body_object => {
              
              'input'=>{csvInstance:[feed.message]}
              
              })
          puts response.to_yaml
          feed.ai_rating = response.data.outputValue
          feed.save
     end
  end
  
  
   def self.train_model(keyword)
     api_client = get_client
     prediction = api_client.discovered_api('prediction', 'v1.6')
     last_ai_training_at = Time.zone.now
     feeds = Tweet.where(keyword:keyword).where("updated_at >= ?",keyword.last_ai_training_at).where.not(user_rating:nil)
     if keyword.ai_url==nil && feeds.count>20  
       tdata = []
       feeds.each do |feed|
         tdata.push({"output" => feed.user_rating, "csvInstance" => [feed.message]})
       end                         
       response   = api_client.execute(
              :api_method => prediction.trainedmodels.insert,
              parameters:{
              project:"929083618245"},
              :body_object => {
              'id' => keyword.nickname.gsub(/[^[:alnum:]]/, ""),
              trainingInstances:tdata,
              'modelType' => 'REGRESSION'
              
              })
       keyword.ai_url= response.data.selfLink
       keyword.last_ai_training_at= last_ai_training_at
       keyword.save
     end
  end
  
  
  def self.get_client()
    client = Google::APIClient.new
    key = Google::APIClient::PKCS12.load_key(Rails.root+"gapi-privatekey.p12", "notasecret")
    asserter = Google::APIClient::JWTAsserter.new(
     '929083618245-qhl7mp539kh5306agugc03nmhk1psjg8@developer.gserviceaccount.com',
     'https://www.googleapis.com/auth/prediction',
     key)

    client.authorization = asserter.authorize()
    return client
  end

end