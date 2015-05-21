class RepliesController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_user!, except: [:index, :show]
  # include NotificationConcern
  # include PostsLikeableHelper

  def index
    # Created in order to handle renders from this controller, which produce URL 'root/posts/:id/comments'
    post = Comment.includes(:user, :post, :replies).find(params[:comment_id]).post
    10.times {puts params}
    redirect_to post
  end

  def create
    @comment = Comment.find(params[:comment_id])
    @post = @comment.post
    @reply = @comment.replies.build(reply_params)

    if @reply.save
      # Notifyer::Notification.notify_all(@reply, @comment)
      # flash.keep[:success] = "Your comment has posted"
      # @new_reply = @comment.replies.new
      respond_to do |format|
        format.html { redirect_to @post }
        format.js
      end
    else
      # @new_reply = @reply
      error = @reply.errors[:body]
      # flash.keep[:danger] = "#{error.count} error(s) prohibited this comment from being saved: #{error.join(", ")}"
      respond_to do |format|
        format.html { render @reply }
        format.js { render action: 'failed_save'}
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:comment_id])
    @post    = @comment.post
    @reply   = Reply.find(params[:id])

    @reply.destroy
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

    def reply_params
      params.require(:reply).permit(:body, :comment_id, :user_id)
    end
end
