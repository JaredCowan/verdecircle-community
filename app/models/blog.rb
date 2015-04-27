class Blog < ActiveRecord::Base
  belongs_to :user

  default_scope -> { order('created_at DESC') }

  validates :subject, presence: true,
            length: { minimum: 3, maximum: 100 }

  validates :body, presence: true,
            length: { minimum: 3, maximum: 100000 }

  validates :user_id, presence: true

  # validates :tags, presence: true

  has_attached_file :image,
    url: "/system/blog/images/:id/:style/:hash.:extension",
    hash_secret: "hashedSecretString",
    preserve_files: "false",
    styles: {
      thumb:    ["100x100#", :png],
      small:    ["150x150>", :png],
      medium:   ["200x200",  :png],
      original: ["*x*",      :png]
  }

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates_attachment_file_name :image, matches: [/png\Z/, /jpg\Z/, /gif\Z/, /jpeg\Z/]
  validates_attachment :image, content_type: { content_type: ["image/jpeg", "image/jpg", "image/gif", "image/png"] }

  # has_many :taggings, dependent: :destroy
  # has_many :tags, through: :taggings, dependent: :destroy

  # @private
  before_save :destroy_image?
  before_save :format_blog_subject

  paginates_per 10

  def to_param
    "#{id}-#{subject.parameterize}"
  end

  def image_delete
    @image_delete ||= "0"
  end

  def image_delete=(value)
    @image_delete = value
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    names     = names.split(",").map {|name| name.downcase.strip.parameterize}.uniq.join(",")
    self.tags = names.split(",").map do |n|
      n = ActionController::Base.helpers.strip_tags(n)
      Tag.where(name: n).first_or_create!
    end
  end

  class << self
    def tagged_with(name)
      Tag.find_by_name!(name).posts
    end

    def tag_counts
      Tag.select("tags.id, tags.name,count(taggings.tag_id) as count").
        joins(:taggings).group("taggings.tag_id, tags.id, tags.name")
    end
  end

  private

    def format_blog_subject
      self.subject = subject.downcase
    end

    def destroy_image?
      self.image.clear if @image_delete == "1"
    end
end
