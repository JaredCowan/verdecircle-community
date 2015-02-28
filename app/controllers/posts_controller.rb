class PostsController < ApplicationController
  skip_authorization_check
  # load_and_authorize_resource
  before_filter :authenticate_user!, except: [:index, :show]
  respond_to :html, :json

  def index
    @posts = Post.all

    respond_to do |format|
      format.html
      format.json { render json: @posts, include: [:user, :get_upvotes, :get_downvotes, :activities] }
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = current_user.posts.new(post_params)

    respond_to do |format|
      if @post.save
        current_user.create_activity(@post, 'created')
        format.html { redirect_to :back }
        format.json { render json: @post, post: :created, location: @post }
        flash[:success] = "Post was successfully created."
      else
        format.html { redirect_to :back, notice: "#{@post.errors.count} error(s) prohibited this post from being saved: #{@post.errors.full_messages.join(', ')}  " }
        format.json { render json: @post.errors, post: :unprocessable_entity }
      end
    end
  end

  def update
    if current_user
      @post     = Post.find(params[:id])
      # Only create activity for updates every 30min to prevent flooding
      if current_user.activities.where(targetable_type: "post").empty? ||
        (!current_user.activities.where(targetable_type: "post").empty? && current_user.activities.where(targetable_type: "post").last.created_at < 30.minutes.ago)
        current_user.create_activity(@post, 'updated')
      end
      # @document = @post.document
    else
      @post     = current_user.posts.find(params[:id])
      # @post.document.user_id = current_user.id
      # @document = @post.document
    end

    respond_to do |format|
      if @post.update_attributes(post_params)
        format.html { redirect_to :back }
        format.json { head :no_content }
        flash[:success] = "Post was successfully updated."
      else
        redirect_to :back
        # format_generic_error("edit")
      end
    end
  end

  def destroy
    @post = Posts.find(params[:id])

    respond_to do |format|
      if @post.destroy
        format.html { redirect_to :back }
        format.json { head :no_content }
        flash[:success] = "Post was successfully deleted."
      else
        # format_generic_error("index")
      end
    end
  end

  def liked
    @post = Post.find(params[:id])
    current_user.create_activity(@post, 'liked')
    @post.liked_by current_user, :vote_weight => 1
    redirect_to :back
    # respond_to do |format|
    #   format.html {redirect_to :back }
    #   format.json { render json: @post, include: [:get_upvotes] }
    # end
  end

  def unliked
    @post = Post.find(params[:id])
    @activity = Activity.find_by(targetable_id: @post)
    @activity.destroy!
    @post.unliked_by current_user, :vote_weight => 1
    redirect_to :back
    # respond_to do |format|
    #   format.html {redirect_to :back }
    #   format.json { render json: @post, include: [:get_upvotes] }
    # end
  end

  def disliked
    @post = Post.find(params[:id])
    current_user.create_activity(@post, 'disliked')
    @post.disliked_by current_user, :vote_weight => 1
    redirect_to :back
    # respond_to do |format|
    #   format.html {redirect_to :back }
    #   format.json { render json: @post, include: [:get_upvotes] }
    # end
  end

  def undisliked
    @post = Post.find(params[:id])
    @activity = Activity.find_by(targetable_id: @post)
    @activity.destroy!
    @post.undisliked_by current_user, :vote_weight => 1
    redirect_to :back
    # respond_to do |format|
    #   format.html {redirect_to :back }
    #   format.json { render json: @post, include: [:get_upvotes] }
    # end
  end

  private

  def post_params
    params.require(:post).permit(:subject, :body, :document_attributes, :attachment)
  end
end
