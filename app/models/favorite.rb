class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :favorable, polymorphic: true
  has_many :activities, as: :targetable, dependent: :destroy
  validates :user_id, :favorable_id, :favorable_type, presence: true
end
