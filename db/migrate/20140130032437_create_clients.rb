class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :first_name
      t.string :last_name
      t.string :company
      t.text :address
      t.string :phone
      t.string :alternate_phone
      t.text :notes

      t.timestamps
    end
  end
end
