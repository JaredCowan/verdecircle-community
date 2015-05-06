class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic

  default_scope -> { order('created_at DESC') }

  # before_save :hash_filename

  validates :subject, presence: true,
            length: { within: 10..60,
            too_short: "must have be at least %{count} characters in length",
            too_long: "must be no longer than %{count} characters in length" }

  validates :body, presence: true,
            length: { minimum: 3, maximum: 100000 }

  validates :topic_id, presence: true

  validates :tag_list, presence: true
  # validate :tag_length_error_validator

  acts_as_votable
  has_paper_trail
  acts_as_paranoid

  # validate :is_user_spaming?, if: Proc.new { |c| c.user.is_admin? }, on: [:create]

  has_attached_file :image,
    path: "user-content/uploads/:class/:id/:style/:hash.:extension",
    hash_secret: "hashedSecretString",
    preserve_files: "true",
    storage: :fog,
    fog_credentials: "#{Rails.root}/config/google_cloud.yml",
    fog_directory: "verde-cdn",
    styles: {
      thumb:    ["100x100#", :png],
      small:    ["150x150>", :png],
      medium:   ["200x200",  :png],
      original: ["*x*",      :png]
  }

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates_attachment_file_name :image, matches: [/png\Z/, /jpg\Z/, /gif\Z/, /jpeg\Z/]
  validates_attachment :image, content_type: { content_type: ["image/jpeg", "image/jpg", "image/gif", "image/png"] }

  has_many :activities, as: :targetable, dependent: :destroy
  has_many :favorites, as: :favorable, dependent: :destroy

  has_many :notifications, as: :notifyable,
                           class_name: "Notifyer::Notification",
                           dependent: :destroy
  # has_many :optouts, class_name: "Notifyer::NotificationOptOuts", dependent: :destroy

  has_many :comments, -> { order("comments.cached_weighted_score DESC, comments.created_at ASC") }, dependent: :destroy

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings, dependent: :destroy
  has_many :votes, class_name: 'ActsAsVotable::Vote', foreign_key: 'votable_id', dependent: :destroy
  has_many :reported, -> { where votes: { vote_scope: 'reported'} }, class_name: 'ActsAsVotable::Vote', foreign_key: 'votable_id', dependent: :destroy
  has_many :versions, -> { where versions: { item_type: 'Post'} }, class_name: 'PaperTrail::Version', foreign_key: 'item_id', dependent: :destroy

  scope :reported, lambda { ActsAsVotable::Vote.where(vote_scope: 'reported') }

  before_save :destroy_image?
  before_save :format_post

  paginates_per 10

  def hash_filename
    if !(self.image && self.image_file_name.nil?)
      ext = File.extname(self.image_file_name)
      return self.image_file_name = SecureRandom.urlsafe_base64(40, false) + ext
    end
  end

  def image_delete
    @image_delete ||= "0"
  end

  def timestamp
    created_at.strftime('%d %B %Y %H:%M:%S')
  end

  def image_delete=(value)
    @image_delete = value
  end

  def to_param
    "#{id}-#{subject.parameterize}"
  end

  def counter
    return comments.map(&:id).compact.length
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

  def format_post
    self.subject = subject.downcase
  end

  def optouts
    Notifyer::NotificationOptOut.where(notifyable_id: self.id)
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

  def destroy_image?
    self.image.clear if @image_delete == "1"
  end

  def is_user_spaming?
    user_posts     = Post.where("user_id = ? AND created_at > ?", user_id, Time.now - 3.hours)
    reported_posts = Post.reported.where("created_at > ? AND votable_id IN (?)", Time.now - 2.days, user_posts.map(&:id))
    if user_posts.length >= 5 || reported_posts.length >= 3
      self.errors.clear
      self.errors[:post] << "Our system has detected spam from your account. Please try again later."
    end
  end

  def tag_length_error_validator
    tags = tag_list.split(", ")
    max_tags_count_per_post_error = true unless tags.length <= 5
    errors_array = []

    tags.each do |t|
      _t_length = t.delete("-").length

      case _t_length
      when 20..(1.0/0.0)
        _length_in_words, _min_max, _count = "long", "maximum", "25"
        has_min_max_length_error = true
      when 0..3
        _length_in_words, _min_max, _count = "short", "minimum", "5"
        has_min_max_length_error = true
      end

      errors_array.push("Your tag '#{t.truncate(35)}' is too #{_length_in_words}. The #{_min_max} is #{_count} characters") if has_min_max_length_error
    end

    errors_array.push("Please limit your tags count to only 5 (You currently have '#{tags.length}')") if max_tags_count_per_post_error
    
    self.errors[:tag] << "have #{errors_array.length}" + "\serror".pluralize(errors_array.length) unless errors_array.empty?
    errors_array.each {|e| self.errors[:base] << "#{e}"}
  end
end
