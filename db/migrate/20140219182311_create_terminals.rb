class CreateTerminals < ActiveRecord::Migration
  def change
    create_table :terminals do |t|
      t.string :name
      t.boolean :publishable
      t.boolean :enabled
      t.boolean :readable

      t.timestamps
    end
  end
end
