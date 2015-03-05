class UserRelationshipsController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_user!
  respond_to :html, :json

  def index
    @user_relationships = UserRelationshipDecorator.decorate_collection(follower_association.all)
    respond_with(@user_relationships)
  end

  def accept
    @user_relationship = current_user.user_relationships.find(params[:id])

    if @user_relationship.accept!
      # current_user.create_activity(@user_friendship, 'accepted')
      # current_user.create_activity(@user_relationship, 'accepted')
      flash[:success] = "You are now following #{@user_relationship.follower.username}"
    else
      flash[:error] = "That friendship could not be accepted."
    end
    redirect_to user_relationships_path
  end

  def block
    @user_relationship = current_user.user_relationships.find(params[:id])
    if @user_relationship.block!

      flash[:success] = "You have blocked #{@user_relationship.follower.username}."
    else
      flash[:error] = "That friendship could not be blocked."
    end
    redirect_to user_relationships_path
  end

  def show
    @user_relationship = current_user.user_relationships.find(params[:id])

    respond_with(@user_friendships)
  end

  def new
    if params[:follower_id]
      @friend = User.find_by(username: params[:username])
      @user_friendship = current_user.user_relationships.new(follower: @friend)
    else
      flash[:error] = "Error"
    end
    redirect_to :back
  end

  def create
    if params.has_key?(:follower_id)
      @follower = User.find(params[:follower_id])
      UserRelationship.request(current_user, @follower)
      @user_relationship = UserRelationship.where(user_id: current_user.id, follower_id: @follower.id)

      redirect_to :back
    end
  end

  def edit
    @friend = User.find(params[:user_id])
    @user_relationship = current_user.user_relationships.where(user_id: @friend.id).first.decorate
  end

  def destroy
    @user_relationship = current_user.user_relationships.find(params[:id])
    if @user_relationship.destroy
      # current_user.destroy_activity(@user_relationship, "accepted")
      flash[:success] = "Friendship destroyed"
    end
    redirect_to user_relationships_path
  end

  private

    def user_relationship_params
      params.require(:user_relationship).permit(:user_id, :follower_id, :state)
    end

    def follower_association
      case params[:list]
        when nil
          current_user.user_relationships
        when 'blocked'
          current_user.blocked_user_relationships
        when 'pending'
          current_user.pending_user_relationships
        when 'accepted'
          current_user.accepted_user_relationships
        when 'requested'
          current_user.requested_user_relationships
      end
    end
end
