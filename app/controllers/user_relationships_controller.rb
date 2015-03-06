class UserRelationshipsController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_user!
  respond_to :html, :json

  def index
    @user = User.find_by(username: params[:username])

    if params[:path] && params[:path] == 'following'
      @user_relationships = UserRelationshipDecorator.decorate_collection(follower_association.all)
      respond_with(@user_relationships, @user)
    else
      @user_relationships = UserRelationshipDecorator.decorate_collection(follower_association.all)
      respond_with(@user_relationships, @user)
    end
  end

  def show
    @user_relationship = current_user.user_relationships.find(params[:id])

    respond_with(@user_relationship)
  end

  def new
    if params[:follower_id]
      @relationship      = User.find_by(username: params[:username])
      @user_relationship = current_user.user_relationships.new(follower: @relationship)
    else
      flash[:error] = "Error"
    end
    redirect_to :back
  end

  def create
    if params.has_key?(:follower_id)
      @relationship = User.find(params[:follower_id])
      UserRelationship.request(current_user, @relationship)
      @user_relationship = UserRelationship.where(user_id: current_user.id, follower_id: @relationship.id)

      redirect_to :back
    end
  end

  def destroy
    user_relationship = current_user.user_relationships.where("follower_id = ?", params[:id])
    user_relationship.first.destroy
    redirect_to :back
  end

  private

    def user_relationship_params
      params.require(:user_relationship).permit(:user_id, :follower_id, :state)
    end

    def follower_association
      case params[:path]
        when 'following'
          current_user.followings
        when 'followers'
          current_user.followers
        else
          current_user.user_relationships
      end
    end
end
