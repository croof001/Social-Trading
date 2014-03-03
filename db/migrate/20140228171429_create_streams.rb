class CreateStreams < ActiveRecord::Migration
  def change
    create_table :streams do |t|
      t.text :content
      t.string :c2
      t.string :c3
      t.string :c4
      t.string :from_id
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
