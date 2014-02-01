class AddFieldsToClientModel < ActiveRecord::Migration
  
    def self.up
    change_table(:clients) do |t|
       t.string :name_on_twitter
       t.string :screen_name
       t.string :url
       t.string :profile_image_url
       t.string :location
       t.text :description
    end
    end
end
