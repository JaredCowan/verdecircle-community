class UsersController < ApplicationController
  load_and_authorize_resource
  before_filter :authenticate_user!, only: [:edit, :update, :destroy]

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
  end

  def profile
    @user = User.find_by(username: params[:username]).decorate
  end
end
