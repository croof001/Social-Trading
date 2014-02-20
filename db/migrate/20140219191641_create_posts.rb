class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.string :content_type
      t.references :account, index: true
      t.string :published_url
      t.boolean :posted
      t.datetime :post_at
      t.references :client, index: true
      t.string :secondary_accounts

      t.timestamps
    end
  end
end
