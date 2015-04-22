class UsersController < ApplicationController
  include AuthFilterConcern
  # skip_authorization_check
  before_filter :authenticate_user!, except: [:index, :show, :profile, :report]
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

  def dashboard
    if user_signed_in?
      @user = User.includes(:posts, :comments, :favorites, posts: [{comments: :votes}, :votes]).find(current_user)
    else
      redirect_to :user_home
    end
  end

  def profile
    @user    = User.find_by(username: params[:username].downcase).decorate
    @actions = User.includes(:posts, :comments, :user_relationships)

    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  def report
    post     = Post.find(params[:id])
    hasVoted = post.votes.where("vote_scope = ? AND voter_id = ?", "reported", current_user.id)

    if hasVoted.length < 1
      post.disliked_by current_user, vote_scope: "reported"

      respond_to do |format|
        format.json { render json: post, status: 200 }
      end
    else
      respond_to do |format|
        format.json { render json: {reason: "Already Reported"}, status: 302 }
      end
    end
  end

  def not_found
    flash.keep[:danger] = "Sorry, there was an error on our end. We have been notified and we'll get right on it."
    @notFoundReturnUrl = request.env["HTTP_REFERER"] ||= :root
    redirect_to @notFoundReturnUrl
  end
end
