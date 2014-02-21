class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :account_type ,:limit=>5
      t.boolean :publishable
      t.boolean :primary
      t.boolean :active
      t.string :username
      t.string :email
      t.string :cred1
      t.string :cred2
      t.string :cred3
      t.references :client
      t.timestamps
    end
  end
end
