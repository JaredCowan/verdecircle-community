class UsersController < ApplicationController
  load_and_authorize_resource
  before_filter :authenticate_user!, only: [:edit, :update, :destroy]

  rescue_from NoMethodError, with: :not_found
  rescue_from ActionController::RoutingError, with: :not_found

  def index

    @users = User.all
    respond_to do |format|
      format.html
      format.json { render json: @users, include: [:activities, :posts] }
    end
  end

  def show
    # Don't Use. 
    # Use profile method.
    redirect_to :not_found
  end

  def profile
    @user = User.find_by(username: params[:username]).decorate
  end

  def not_found
    flash.keep[:danger] = "Sorry, we couldn't find that users profile that you were looking for."
    @notFoundReturnUrl = request.env["HTTP_REFERER"] ||= :root
    redirect_to @notFoundReturnUrl
  end
end
