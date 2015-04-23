class CommentsController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_user!
  include NotificationConcern
  include PostsLikeableHelper

  def index
    # Created in order to handle renders from this controller, which produce URL 'root/posts/:id/comments'
    @post     = Post.includes(:user, comments: [:user, :votes]).find(params[:post_id])
    @comments = @post.comments.includes({user: :votes})
    # redirect_to @post

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @comments }
    end
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    # @new_reply = @comment.replies.new
    @likes = query_votes(@post)

    if @comment.save
      Notifyer::Notification.notify_all(@comment, @post)
      @new_comment = @post.comments.new
      respond_to do |format|
        format.html { redirect_to @post }
        format.js
        format.json { render json: @post }
      end
    else
      @new_comment = @comment
      error = @comment.errors[:body]
      flash.now[:danger] = "#{error.count} error(s) prohibited this comment from being saved: #{error.join(", ")}"
      respond_to do |format|
        format.html { render @post }
        format.js { render action: 'failed_save'}
        format.json { render json: @post.errors, post: :unprocessable_entity }
      end
    end
  end

  def show
    @post        = Post.includes(:user, comments: [:user, :votes]).find(params[:post_id])
    @comment     = @post.comments.includes({user: :votes}).find(params[:id])
    @comments    = @post.comments.includes({user: :votes})
    @replies     = @comment.replies

    respond_to do |format|
      format.html
      format.js
      format.json { render json: @comment }
    end

    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { redirect_to @post }
        format.json { render text: "Not Found", comment: :unprocessable_entity }
        flash.keep[:danger] = "Sorry, this comment has been deleted or has moved"
      end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post
    @comment.destroy
    respond_to do |format|
      format.html do
        redirect_to @post
      end
      format.js
    end
  end

  def liked
    @comment = Comment.find(params[:id])
    # current_user.create_activity(@post, 'liked')
    @comment.liked_by current_user, :vote_weight => 1
    redirect_to :back
  end

  def unliked
    @comment = Comment.find(params[:id])
    # current_user.destroy_activity(@post, "liked")
    @comment.unliked_by current_user, :vote_weight => 1
    redirect_to :back
  end

  def disliked
    @comment = Comment.find(params[:id])
    # current_user.create_activity(@post, 'disliked')
    @comment.disliked_by current_user, :vote_weight => 1
    redirect_to :back
  end

  def undisliked
    @comment = Comment.find(params[:id])
    # @activity = Activity.find_by(targetable_id: @post)
    # @activity.destroy!
    @comment.undisliked_by current_user, :vote_weight => 1
    redirect_to :back
  end

  private

    def comment_params
      params.require(:comment).permit(:body, :post_id, :user_id)
    end
end
