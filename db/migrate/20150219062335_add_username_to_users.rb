class AddUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string, :unique => true, :default => '', :null => false
  end
end
