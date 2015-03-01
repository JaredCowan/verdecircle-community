class PaperclipImage < ActiveRecord::Base
  has_attached_file :asset
  validates_attachment_content_type :asset, :content_type => /\Aimage\/.*\Z/

end
