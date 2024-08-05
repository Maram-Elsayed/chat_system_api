class AddIndexesToModels < ActiveRecord::Migration[6.0]
  def up
    add_index :applications, :token, unique: true
    add_index :chats, [:application_id, :number], unique: true
    add_index :messages, [:chat_id, :number], unique: true
    add_index :messages, :body, length: { body: 255 }
  end

  def down
    remove_index :applications, :token, unique: true
    remove_index :chats, [:application_id, :number], unique: true
    remove_index :messages, [:chat_id, :number], unique: true
    remove_index :messages, :body, length: { body: 255 }
  end
end
