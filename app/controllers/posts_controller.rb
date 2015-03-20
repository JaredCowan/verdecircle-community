class PostsController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_user!, except: [:index, :show]
  respond_to :html, :json, :js

  include NotificationConcern if Rails.application.routes.recognize_path('/')[:action] == "dashboard"

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  
  def index
    if params[:tag]
      begin
        @posttag = Post.tagged_with(params[:tag]).decorate
      rescue ActiveRecord::RecordNotFound  
        flash.keep[:danger] = "Sorry, we couldn't find anything with that tag."
        @notFoundReturnUrl = request.env["HTTP_REFERER"] ||= posts_path
        redirect_to @notFoundReturnUrl
      end
    else
      @posts = Post.includes(:votes, :comments, :tags, :topic, :favorites, {user: :votes}).order(:created_at).page(params[:page]).decorate

      respond_to do |format|
        format.html
        # format.js
        format.json { render json: @posts, include: [:comments, :user, :votes, :activities] }
      end
    end
  end

  def show
    @post        = Post.includes(:tags, :taggings, :user, :favorites, comments: [:votes]).find(params[:id])
    @comments    = @post.comments.includes(:votes)
    @new_comment = @post.comments.new
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
    @new_topic = Topic.new
  end

  def create
    @post = current_user.posts.new(post_params)
    @post.subject = ActionController::Base.helpers.strip_tags(@post.subject)
    @post.body = ActionController::Base.helpers.strip_tags(@post.body)

    respond_to do |format|
      if @post.save
        current_user.create_activity(@post, 'created')
        format.html { redirect_to @post }
        format.json { render json: @post, post: :created, location: @post }
        flash[:success] = "Post was successfully created."
      else
        format.html { render :new }
        format.json { render json: @post.errors, post: :unprocessable_entity }
        flash.now[:danger] = "#{@post.errors.count} error(s) prohibited this post from being saved: #{@post.errors.full_messages.join(', ')}"
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
        flash.keep[:success] = "There was an error deleting this post."
        redirect_to not_found
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
    view_context.link_to("undo", revert_version_path(@post.versions.scoped.last), :method => :post)
  end

  def not_found
    flash.keep[:danger] = "Sorry, we couldn't find that post you were looking for."
    redirect_to controller: "posts", action: "index"
  end

  private

  def post_params
    params.require(:post).permit(:subject, :body, :image, :image_delete, :topic_id, :tag_list)
  end
end
