class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats, :id => false do |t|
      t.integer :id, null: false, auto_increment: true, primary_key: true
      t.integer :from_user_id, null: false
      t.integer :to_user_id, null: false
      t.string :text, null: false
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
