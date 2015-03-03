class AddDeletedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :deleted_at, :datetime
    add_index :users, :deleted_at

    add_column :posts, :deleted_at, :datetime
    add_index :posts, :deleted_at

    add_column :comments, :deleted_at, :datetime
    add_index :comments, :deleted_at
  end
end
