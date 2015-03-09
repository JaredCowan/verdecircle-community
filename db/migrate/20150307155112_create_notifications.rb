class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id, index: true
      t.integer :sender_id, index: true

      t.boolean :is_read, default: false

      t.integer :notifyable_id, null: false, default: ''
      t.string  :notifyable_type, null: false, default: ''

      t.timestamps
    end

    add_index :notifications, [:notifyable_id, :notifyable_type]

    add_index :notifications, [:user_id, :sender_id]

    add_index :notifications, :is_read
  end
end
