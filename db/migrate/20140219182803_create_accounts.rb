class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :terminal, index: true
      t.boolean :active
      t.string :username
      t.string :cred1
      t.string :cred2
      t.string :cred3
      t.references :client
      t.timestamps
    end
  end
end
