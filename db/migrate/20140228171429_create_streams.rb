class CreateStreams < ActiveRecord::Migration
  def change
    create_table :streams do |t|
      t.string :content
      t.string :c2
      t.references :post, index: true
      t.string :stream_type
      t.references :account, index: true
      t.string :remote_url
      t.string :remote_id
      t.integer :parent
      t.boolean :read
      t.datetime :posted_at

      t.timestamps
    end
  end
end
