module Notifyer
  class Notification < ActiveRecord::Base
    # Specifically define name of table
    self.table_name = :notifications

    default_scope -> { order('created_at DESC') }

    belongs_to :user
    belongs_to :sender, class_name: "User", foreign_key: "sender_id"
    belongs_to :notifyable, polymorphic: true
    # has_many :optouts, class_name: "Notifyer::NotificationOptOut", foreign_key: "notification_id"

    # Basic scopes for common queries
    scope :unread,       lambda { where(is_read: false) }
    scope :unread_count, lambda { where(is_read: false).count }
    scope :read,         lambda { where(is_read: true) }

    class << self
      # Creator is the object that triggered notification
      # Object is the notifyable object
      def notify_all(object, target, user)
        # Array where we will push all the users to notify
        notifyUserIds = []
        # Owner of the master object
        owner = [] << target.user.id.to_s
        # Class name of the object
        klass    = target.class.name.constantize
        comments = target.comments.map(&:user_id).uniq

        notifyUserIds = comments
        # .delete_if {|n| n == creator.user.id or n == nil}

        # optouts = Notifyer::NotificationOptOut.where(notifyable_id: target.id, notifyable_type: "#{klass}").map(&:user_id)
        optouts = target.optouts.map(&:user_id).uniq
        optouts.each do |optout|
          notifyUserIds = notifyUserIds.delete(optout)
        end

        # notifyUserIds.each do |notif|
        #   Notifyer::Notification.create(user_id: notif.to_i, sender_id: creator.user.id.to_i,
        #                                 notifyable_id: object.id, notifyable_type: "#{klass}"
        #   )
        # end
        # puts creator.class.name
        # puts ""
        # puts ""
        # puts object
        20.times { puts object }
        20.times { puts target }
        20.times { puts user }
        # 5.times { puts optouts }
        5.times { puts notifyUserIds }
        # 5.times { puts comments }
      end

      def notify_user(creator, object, action)
        Notifyer::Notification.create(user_id: object.post.user.id.to_i,
                                      sender_id: creator.id.to_i,
                                      action: "#{action}",
                                      notifyable_id: object.post_id.to_i,
                                      notifyable_type: "Post"
        )
      end
    end
  end
end
