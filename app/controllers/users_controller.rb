class UsersController < ApplicationController
  load_and_authorize_resource
  before_filter :authenticate_user!
  respond_to :html, :json

  include CommonHelper

  rescue_from NoMethodError, with: :not_found if ENV['production']

  # Commenting this error catch out for now.
  # 
  # Seems to be throwing an error when logging-in. Look into it.
  # rescue_from ActionController::RoutingError, with: :not_found

  def index
    @users = User.all.decorate
    respond_to do |format|
      format.html
      format.json { render json: @users, include: [:user_relationships, :activities, :posts] }
    end
  end

  def show
    # Don't Use. 
    # Use profile method.
    redirect_to :root
  end

  def profile
    @user = User.find_by(username: params[:username].downcase).decorate
    @actions = User.includes(:posts, :comments, :user_relationships)
  end

  def not_found
    flash.keep[:danger] = "Sorry, there was an error on our end. We have been notified and we'll get right on it."
    @notFoundReturnUrl = request.env["HTTP_REFERER"] ||= :root
    redirect_to @notFoundReturnUrl
  end
end
