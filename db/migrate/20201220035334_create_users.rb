class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, :id => false do |t|
      t.integer :id, null: false, auto_increment: true, primary_key: true
      t.string :name
      t.string :email
      t.string :phone_number
      t.string :password_digest

      t.timestamps
    end
  end
end