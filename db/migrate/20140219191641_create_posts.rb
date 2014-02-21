class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text   :content
      t.string :content_type
      t.references :account, index: true
      t.integer :parent_id
      t.string :published_url
      t.boolean :posted
      t.datetime :post_at
      t.references :client, index: true
      t.timestamps
    end
  end
end
