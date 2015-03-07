class Post < ActiveRecord::Base

  belongs_to :user
  belongs_to :topic

  default_scope -> { order('created_at DESC') }

  validates :subject, presence: true,
            length: { minimum: 3, maximum: 60 }

  validates :body, presence: true,
            length: { minimum: 3, maximum: 4000 }

  validates :topic_id, presence: true

  acts_as_votable
  has_paper_trail
  acts_as_paranoid
  
  has_attached_file :image
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates_attachment_file_name :image, :matches => [/png\Z/, /jpg\Z/, /gif\Z/, /jpeg\Z/]
  validates_attachment :image,
  :content_type => { :content_type => ["image/jpeg", "image/jpg", "image/gif", "image/png"] }

  has_many :activities, as: :targetable, dependent: :destroy
  has_many :favorites, as: :favorable, dependent: :destroy

  has_many :comments, dependent: :destroy

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings, dependent: :destroy

  before_save :destroy_image?

  paginates_per 15

  def image_delete
    @image_delete ||= "0"
  end

  def timestamp
    created_at.strftime('%d %B %Y %H:%M:%S')
  end

  def image_delete=(value)
    @image_delete = value
  end

  # def username
    # user.username
  # end

  def to_param
    "#{id}-#{subject.parameterize}"
  end

  def self.tagged_with(name)
    Tag.find_by_name!(name).posts
  end

  def self.tag_counts
    Tag.select("tags.id, tags.name,count(taggings.tag_id) as count").
      joins(:taggings).group("taggings.tag_id, tags.id, tags.name")
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where(name: n.downcase.strip.parameterize).first_or_create!
    end
  end

  private

  def destroy_image?
    self.image.clear if @image_delete == "1"
  end
end
