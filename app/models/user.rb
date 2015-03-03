class User < ActiveRecord::Base
  include Concerns::UserImagesConcern
  include Concerns::UserActivityConcern
  acts_as_messageable
  acts_as_voter
  has_paper_trail
  acts_as_paranoid

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable, :lockable, :async

  has_attached_file :avatar
  # validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :activities, dependent: :destroy

  has_many :authentications, dependent: :destroy, validate: false, inverse_of: :user do
    def grouped_with_oauth
      includes(:oauth_cache).group_by {|a| a.provider }
    end
  end

  before_save { self.username = self.username.gsub(/[^a-z]/i, '') }
  validates :username, presence: true, 
            length: { minimum: 3, maximum: 20 },
            uniqueness: { case_sensitive: false }

  after_create :send_welcome_emails
  default_scope -> { order('username ASC') }

  def display_name
    first_name.presence || email.split('@')[0]
  end

  def full_name
    "#{username}"
  end

  def name_with_initial
    "#{username}"
  end

  def mailboxer_email(object)
    email
  end

  # Case insensitive email lookup.
  #
  # See Devise.config.case_insensitive_keys.
  # Devise does not automatically downcase email lookups.
  def self.find_by_email(email)
    find_by(email: email.downcase)
    # Use ILIKE if using PostgreSQL and Devise.config.case_insensitive_keys=[]
    #where('email ILIKE ?', email).first
  end

  # Finds users profile page by username
  def self.find_by_username(username)
    find_by(username: username.downcase)
  end

  # Override Devise to allow for Authentication or password.
  #
  # An invalid authentication is allowed for a new record since the record
  # needs to first be saved before the authentication.user_id can be set.
  def password_required?
    if authentications.empty?
      super || encrypted_password.blank?
    elsif new_record?
      false
    else
      super || encrypted_password.blank? && authentications.find{|a| a.valid?}.nil?
    end
  end

  # Merge attributes from Authentication if User attribute is blank.
  #
  # If User has fields that do not match the Authentication field name,
  # modify this method as needed.
  def reverse_merge_attributes_from_auth(auth)
    auth.oauth_data.each do |k, v|
      self[k] = v if self.respond_to?("#{k}=") && self[k].blank?
    end
  end

  # Do not require email confirmation to login or perform actions
  def confirmation_required?
    false
  end

  def send_welcome_emails
    UserMailer.delay.welcome_email(self.id)
    # UserMailer.delay_for(5.days).find_more_friends_email(self.id)
  end
end
