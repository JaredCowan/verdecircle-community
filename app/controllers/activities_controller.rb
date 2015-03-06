class ActivitiesController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_user!
  respond_to :html, :json

  def index
    if params[:user] == current_user.username.downcase
      @activities = current_user.activities
    else
      flash.keep[:danger] = "Sorry, You're not authorized to view the feed for #{params[:user]}" unless params[:user].nil?

      activity = []

      activities = Activity.includes(:user)

      activities.all.each do |a|
        current_user.user_relationships.map(&:follower_id).each do |f|
          if a.user_id == f
            activity.push(a)
          end
        end

        case a.user_id
          when current_user.id
            activity.push(a)
        end

        if a.user.is_admin? && !activity.map(&:id).include?(a.id)
          activity.push(a)
        end
      end

      @activities = activity
    end
  end
end
