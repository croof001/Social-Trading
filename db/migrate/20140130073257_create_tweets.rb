class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :author
      t.text :message
      t.string :twitter_uuid
      t.datetime :posted_at
      t.references :client
      t.references :account
      t.references :keyword
      
      t.timestamps
    end
  end
end
