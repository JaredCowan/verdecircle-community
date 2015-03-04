class CreateUserRelationships < ActiveRecord::Migration
  def change
    create_table :user_relationships do |t|
      t.integer :follower_id
      t.integer :followed_id
      t.string :state

      t.timestamps
    end

    add_index :user_relationships, [:follower_id, :followed_id]
    add_index :user_relationships, :state
  end
end
