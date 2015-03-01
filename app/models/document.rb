class Document < ActiveRecord::Base
  attr_accessor :document
  # has_attached_file :attachment
  has_attached_file :document
  # validates_attachment :document,
    # :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/gif", "image/png"] }
  # belongs_to :post
  do_not_validate_attachment_file_type :document
  belongs_to :user
  # has_many :activities, :as => :targetable, :dependent => :destroy
  # validates_attachment_file_name :document, :matches => [/png\Z/, /jpg\Z/, /gif\Z/, /jpeg\Z/, ]


  # attr_accessor :remove_attachment
  # before_save :perform_attachment_removal
  # def perform_attachment_removal
  #   if remove_attachment == '1' && !attachment.dirty?
  #     self.attachment = nil
  #   end
  # end
end
