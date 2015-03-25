class CommentsController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_user!
  include NotificationConcern
  include PostsLikeableHelper

  def index
    # Created in order to handle renders from this controller, which produce URL 'root/posts/:id/comments'
    post = Post.includes(:user, comments: [:user, :votes]).find(params[:post_id])
    redirect_to post
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    # @new_reply = @comment.replies.new
    @likes = query_votes(@post)

    if @comment.save
      Notifyer::Notification.notify_all(@comment, @post)
      flash.now[:success] = "Your comment has posted"
      @new_comment = @post.comments.new
      respond_to do |format|
        format.html do
          flash[:success] = 'Your comment has been posted.'
          redirect_to @post
        end
        format.js
      end
    else
      @new_comment = @comment
      error = @comment.errors[:body]
      flash.now[:danger] = "#{error.count} error(s) prohibited this comment from being saved: #{error.join(", ")}"
      respond_to do |format|
        format.html { render @post }
        format.js { render action: 'failed_save'}
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post
    @comment.destroy
    respond_to do |format|
      format.html do
        flash.keep[:success] = 'Comment deleted.'
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
