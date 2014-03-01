class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text   :content
      t.string :content_type
      t.string :remote_id #ID obtained on publish
      t.references :account, index: true
      t.integer :parent_id #does the object have a parent
      t.string :published_url
      t.boolean :is_draft,:default=>true #Is this post saved as draft
      t.boolean :posted,:default=>false #Is the post published to target already . Set by the publisher module
      t.datetime :post_at #When should be the post to be published
      t.references :client, index: true
      t.string :created_by ,:default=>'System'
      t.timestamps
    end
  end
end
