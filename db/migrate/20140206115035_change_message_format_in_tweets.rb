class ChangeMessageFormatInTweets < ActiveRecord::Migration
  def change
    change_column :tweets ,:message ,:string,:limit => 400
  end
end
