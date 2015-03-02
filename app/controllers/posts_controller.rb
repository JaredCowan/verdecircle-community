class PostsController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_user!, except: [:index, :show]
  respond_to :html, :json

  def index
    @posts = Post.all.order("created_at DESC")

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
    @post = current_user.posts.find(params[:id])
    @post.transaction do
      @post.update_attributes(post_params)
      current_user.create_activity(@post, 'updated')
      unless @post.valid? || (@post.valid? && @post.image && !@post.image.valid?)
        raise ActiveRecord::Rollback
      end
    end
    
    respond_to do |format|
      format.html { redirect_to @post, notice: 'Status was successfully updated.' }
      format.json { head :no_content }
    end
  rescue ActiveRecord::Rollback
    respond_to do |format|
      format.html do
        flash.now[:error] = "Update failed."
        render action: "edit"
      end
      format.json { render json: @post.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])

    respond_to do |format|
      if @post.destroy
        format.html { redirect_to posts_path }
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
  end

  def unliked
    @post = Post.find(params[:id])
    current_user.destroy_activity(@post, "liked")
    @post.unliked_by current_user, :vote_weight => 1
    redirect_to :back
  end

  def disliked
    @post = Post.find(params[:id])
    current_user.create_activity(@post, 'disliked')
    @post.disliked_by current_user, :vote_weight => 1
    redirect_to :back
  end

  def undisliked
    @post = Post.find(params[:id])
    @activity = Activity.find_by(targetable_id: @post)
    @activity.destroy!
    @post.undisliked_by current_user, :vote_weight => 1
    redirect_to :back
  end

  def undo_link
    view_context.link_to("undo", revert_version_path(@product.versions.scoped.last), :method => :post)
  end

  private

  def post_params
    params.require(:post).permit(:subject, :body, :image, :image_delete)
  end
end
