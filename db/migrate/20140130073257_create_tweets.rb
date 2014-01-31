class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :author
      t.text :message
      t.string :author_link
      t.string :message_link
      t.datetime :posted_at
      t.references :client
      t.timestamps
    end
  end
end
