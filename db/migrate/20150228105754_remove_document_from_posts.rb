class RemoveDocumentFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :document_file_name
    remove_column :posts, :document_id
    remove_column :posts, :document_content_type
    remove_column :posts, :document_file_size
    remove_column :posts, :document_updated_at
  end
end
