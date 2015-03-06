class ActivitiesController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_user!
  respond_to :html, :json

  def index
    # Url param for user to filter only their activity
    if params[:user] == current_user.username.downcase
      @activities = current_user.activities
    else
      # Show error message if user entered url param that didn't match their username
      flash.keep[:danger] = "Sorry, You're not authorized to view the feed for #{params[:user]}" unless params[:user].nil?

      # Create empty array to push activity objects too
      # 
      # Eager load @Activity and @User for better, faster and less SQL query's
      buildActivity = []
      activities = Activity.includes(:user)

      # Logic for which Activity objects to push to array
      # 
      # Initial view is current_user objects and objects for Admins
      # More objects are added when users follow other users
      activities.all.each do |a|
        case a.user_id
          when current_user.id
            buildActivity.push(a)
        end

        # Add Admin @activity by default & regardless if there is an @user relationship
        if a.user.is_admin? && !buildActivity.map(&:id).include?(a.id)
          buildActivity.push(a)
        end

        # Create array of user_id => follower_id of @user relationships to map
        current_user.user_relationships.map(&:follower_id).each do |f|
          if a.user_id == f
            # Adds object to @activity if @user is following activity's user_id
            buildActivity.push(a)
          end
        end
      end

      # Assign built activity array to instance variable for view
      @activities = buildActivity
    end
  end
end
