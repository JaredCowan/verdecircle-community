class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :targetable, polymorphic: true
  default_scope -> { order('created_at DESC') }
end
