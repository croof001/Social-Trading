class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string :phrase
      t.integer :priority
      t.references :client, index: true

      t.timestamps
    end
  end
end
