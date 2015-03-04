class CreateUserRelationships < ActiveRecord::Migration
  def change
    create_table :user_relationships do |t|
      t.integer :user_id
      t.integer :follower_id
      t.string :state

      t.timestamps
    end

    add_index :user_relationships, [:user_id, :follower_id]
    add_index :user_relationships, :state
  end
end
