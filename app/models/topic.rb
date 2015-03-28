class Topic < ActiveRecord::Base
  has_many :posts
  validates :name,
            presence: true,
            length: { minimum: 3, maximum: 22 },
            uniqueness: { case_sensitive: false }

  paginates_per 2

  before_save :parameterize_name

  def to_param
    "#{name.parameterize}"
  end

  def find_by_name(name)
    find_by(name: name.parameterize)
  end

  def parameterize_name
    self.name = name.parameterize
  end

  def pretty_name
    self.name.titleize
  end
end
