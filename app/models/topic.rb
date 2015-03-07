class Topic < ActiveRecord::Base
  has_many :posts
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  before_save :pretty_name

  def to_param
    "#{name.parameterize}"
  end

  def pretty_name
    self.name = name.downcase.titleize
  end
end
