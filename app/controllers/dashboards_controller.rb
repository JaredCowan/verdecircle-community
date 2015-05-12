class DashboardsController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_user!
  before_filter :set_user
  layout "no_sidebar"

  def index
    @view = params[:soft].downcase.pluralize rescue nil

    respond_to do |format|
      format.html
      format.js { render "dashboards/js/view" }
    end
  end

  private

  def set_user
    @user = User.includes(:posts, :comments, :favorites, posts: [{comments: :votes}, :votes]).find(current_user)
  end
end
