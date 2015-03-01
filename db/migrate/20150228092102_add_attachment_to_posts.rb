class AddAttachmentToPosts < ActiveRecord::Migration
  def change
    add_attachment :posts, :document
  end
end
