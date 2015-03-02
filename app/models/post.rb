class Post < ActiveRecord::Base
  acts_as_votable
  has_paper_trail
  belongs_to :user
  has_attached_file :image
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates_attachment_file_name :image, :matches => [/png\Z/, /jpg\Z/, /gif\Z/, /jpeg\Z/]
  validates_attachment :image,
  :content_type => { :content_type => ["image/jpeg", "image/jpg", "image/gif", "image/png"] }
  has_many :activities, as: :targetable, dependent: :destroy

  validates :subject, presence: true, 
            length: { minimum: 3, maximum: 60 }
  validates :body, presence: true, 
            length: { minimum: 3, maximum: 4000 }

  before_save :destroy_image?

  def image_delete
    @image_delete ||= "0"
  end

  def image_delete=(value)
    @image_delete = value
  end

  private

  def destroy_image?
    self.image.clear if @image_delete == "1"
  end
end
