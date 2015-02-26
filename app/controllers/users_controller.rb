class UsersController < ApplicationController
  load_and_authorize_resource

  def index

    @users = User.all.order("username")
    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end

  def show
  end

  def profile
    @user = User.find_by(username: params[:username]).decorate
  end
end
