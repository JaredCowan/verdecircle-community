class AddActionToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :action, :string, null: false, default: ''
  end
end
