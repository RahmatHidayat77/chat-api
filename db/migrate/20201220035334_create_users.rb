class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, :id => false do |t|
      t.integer :id, null: false, auto_increment: true, primary_key: true
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone_number, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
