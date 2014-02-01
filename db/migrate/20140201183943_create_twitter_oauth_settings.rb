class CreateTwitterOauthSettings < ActiveRecord::Migration
  def change
    create_table :twitter_oauth_settings do |t|
      t.string :atocken
      t.string :secret
      t.references :client, index: true

      t.timestamps
    end
  end
end
