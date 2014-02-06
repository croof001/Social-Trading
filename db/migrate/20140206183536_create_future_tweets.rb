class CreateFutureTweets < ActiveRecord::Migration
  def change
    create_table :future_tweets do |t|
      t.string :message, :length=>360
      t.datetime :post_at
      t.boolean :status

      t.timestamps
    end
  end
end
