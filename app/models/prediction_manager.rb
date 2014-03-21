class PredictionManager
  @project = "929083618245"
  def generate_training_data(keyword)
     tdata = []
     feeds = Tweet.where(keyword:keyword).where("created_at >= ?",keyword.last_ai_training_at).where.not(user_rating:nil)
     feeds.each do |feed|
       tdata.push({"output" => feed.user_rating, "csvInstance" => [feed.message]})
     end
  end
  
   def train_model(keyword)
     api_client = get_client(keyword)
     prediction = api_client.discovered_api('prediction', 'v1.6')
     response = api_client.execute(prediction.trainedmodels.insert,
                                   {id:keyword.nickname ,#get_model_id(keyword),
                                    trainingInstances:generate_training_data(keyword),
                                    project:@project
                                    })
    puts response.data.to_yaml

  end
  
  def get_model_id(keyword)
   response = get_client.execute(prediction.training.insert,
               {'id' => get_model_id(keyword), trainingInstances:generate_training_data})
  end
  
  def get_client(lclient,account=nil)
    client = Google::APIClient.new
    client.authorization.client_id = "929083618245-qsjtatfob874ejnrenepo5srdckm75k3.apps.googleusercontent.com"
    client.authorization.client_secret = "2mCMyE6bOBDrRCYcYk93zgej"
    client.authorization.scope = 'https://www.googleapis.com/auth/prediction'
    client.authorization.redirect_uri = "http://localtest.me:3000"
    if account || account = Account.where(:client=>lclient,:account_type=>'google',:primary=>true,:active=>true).first
      token_hash={:refresh_token => account.cred3, :access_token => account.cred1}
    end

    client.authorization.update_token!(token_hash)
    return client
  end

  def self.store_in_google data
    puts "Uploading #{data.length / 1000 / 1000}MB to google storage..."
    gstore_client.create_bucket(BUCKET) #in case it doesn't exist
    filename = "#{BUCKET}-#{Time.now.to_i}.csv"
    gstore_client.put_object(BUCKET, filename, :data => data)
    filename
  end

  def self.delete_from_google filename
    gstore_client.delete_object(BUCKET, filename)
  end

end