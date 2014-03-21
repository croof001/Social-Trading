require 'gstore'
require 'csv'
require 'google/api_client'
require 'yaml'
 
class GooglePredict
 
BUCKET = "A-GOOGLE-STORAGE-BUCKET-NAME"
 
def self.run(gaccount)
csv_string = CSV.generate do |csv|
#generate a csv with your data...
#csv << ['spam', '.....']
#csv << ['ham', '.....']
end
#filename = store_in_google(csv_string)
 
client = Google::APIClient.new
client.authorization.client_id = "929083618245-qsjtatfob874ejnrenepo5srdckm75k3.apps.googleusercontent.com"
client.authorization.client_secret = "2mCMyE6bOBDrRCYcYk93zgej"
client.authorization.scope = 'https://www.googleapis.com/auth/prediction'
client.authorization.redirect_uri = "http://localtest.me:3000"
code = nil
token_hash = nil
if code.nil?
puts "Please go visit this URL in your browser and copy the new code!"
puts client.authorization.authorization_uri.to_s
return
else
client.authorization.code = code
end
if token_hash.nil?
client.authorization.fetch_access_token!
puts "Copy this as your new token!"
puts "{:refresh_token => '#{client.authorization.refresh_token}', :access_token => '#{client.authorization.access_token}', :expires_at => '#{client.authorization.expires_at}'}"
return
else
client.authorization.update_token!(token_hash)
end
prediction = client.discovered_api('prediction', 'v1.2')
# Make training API call
response = client.execute(prediction.training.insert,{'data' => "#{BUCKET}/#{filename}"})
puts response.to_yaml
# Check Training Status
response = client.execute(prediction.training.get, {'data' => "#{BUCKET}/#{filename}"})
puts response.to_yaml
ensure
#could use this to delete your file in google storage if the training has completed...
#delete_from_google filename
end
def self.gstore_client
@gstore_client ||= GStore::Client.new(
:access_key => "YOUR_GOOGLE_STORAGE_LEGACY_ACCESS_KEY",
:secret_key => "YOUR_GOOGLE_STORAGE_LEGACY_SECRET"
)
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

GooglePredict.run