module Notifyer
  class Notification < ActiveRecord::Base
    self.table_name = :notifications

    belongs_to :user
    belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
    belongs_to :notifyable, polymorphic: true

    default_scope -> { order('created_at DESC') }

    scope :unread,       lambda { where(is_read: false) }
    scope :unread_count, lambda { where(is_read: false).count }
    scope :read,         lambda { where(is_read: true) }

    class << self
      # Creator is the object that triggered notification
      # Object is the notifyable object
      def notify_all(creator, object)
        # Array where we will push all the users to notify
        notifyUserIds = []
        # Owner of the master object
        owner = [] << object.user.id.to_s
        # Class name of the object
        klass = object.class.name.constantize
        comments = object.comments.map(&:user_id).uniq

        notifyUserIds = owner.push(comments).flatten!.delete_if {|n| n == creator.user.id or n == nil}

        optouts = Notifyer::OptOut.where(notifyable_id: object.id, notifyable_type: "#{klass}")
        optouts.each do |optout|
          notifyUserIds = notifyUserIds.delete(optout.user_id)
        end

        notifyUserIds.each do |notif|
          Notifyer::Notification.create(user_id: notif.to_i, sender_id: creator.user.id.to_i,
                                        notifyable_id: object.id, notifyable_type: "#{klass}"
          )
        end
      end
    end
  end
end
