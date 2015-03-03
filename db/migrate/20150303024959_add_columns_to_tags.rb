class AddColumnsToTags < ActiveRecord::Migration
  def change
    add_column :taggings, :post_id, :integer, index: true
    add_column :taggings, :user_id, :integer, index: true

    add_column :tags, :user_id, :integer, index: true
    add_column :tags, :post_id, :integer, index: true
    add_column :tags, :created_at, :datetime
    add_column :tags, :updated_at, :datetime
  end
end
