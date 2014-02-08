class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string :phrase
      t.integer :priority
      t.boolean :auto_follow
      t.boolean :auto_retweet
      t.boolean  :auto_reply
      t.boolean   :geocoded
      t.string   :default_reply
      t.string   :keyword_type, :length=>20
      
      t.string :lattitude, :length=>40
      t.string :longitude, :length=>40
      t.float  :radius
      t.string :notes , :length =>256
      t.string :color ,:length=>12,:default=>'#ffffff'
      t.boolean :read
      t.references :client, index: true
     
      t.timestamps
    end
  end
end
