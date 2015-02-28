class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :document
  has_many :activities, :as => :targetable, :dependent => :destroy
  acts_as_votable

  # has_many :taggings, dependent: :destroy
  # has_many :tags, through: :taggings, dependent: :destroy

  validates :subject, presence: true, 
            length: { minimum: 3, maximum: 50 }
  validates :body, presence: true, 
            length: { minimum: 3 }

  # 
  accepts_nested_attributes_for :document

  # def self.tagged_with(name)
  #   Tag.find_by_name!(name).questions
  # end

  # def self.tag_counts
  #   Tag.select("tags.id, tags.name,count(taggings.tag_id) as count").
  #     joins(:taggings).group("taggings.tag_id, tags.id, tags.name")
  # end   

  # def tag_list
  #   tags.map(&:name).join(", ")
  # end

  # def tag_list=(names)
  #   self.tags = names.split(",").map do |n|
  #     Tag.where(name: n.downcase.strip).first_or_create!
  #   end
  # end
end
