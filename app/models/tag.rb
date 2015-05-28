class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :posts, through: :taggings

  default_scope -> { order('taggings_count DESC') }

  class << self
    def tag_counts
      self.select("name, count(taggings.tag_id) as count").joins(:taggings).group("taggings.tag_id")
    end
  end
end
