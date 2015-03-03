class AddMissingIndicesToTagsAndTaggings < ActiveRecord::Migration
  def change
    add_index :taggings, [:user_id, :post_id]
    add_index :tags, [:user_id, :post_id]
  end
end
