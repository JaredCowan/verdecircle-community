class CommentsController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_user!, except:[:index, :show]
  include NotificationConcern
  include PostsLikeableHelper

  def index
    @post     = Post.includes(:user, comments: [:user, :votes, :replies]).find(params[:post_id])
    @comments = @post.comments.includes({user: :votes}, :replies).page(params[:page])
    @params   = params

    respond_to do |format|
      format.html { redirect_to @post }
      format.js
      format.json { render json: @comments }
    end
  end

  def create
    @post     = Post.find(params[:post_id])
    @comments = @post.comments
    @comment  = @post.comments.build(comment_params)
    # @likes    = query_votes(@post)
    # @new_reply = @comment.replies.new

    if @comment.save
      # Notifyer::Notification.notify_all(@comment, @post, current_user)
      @new_comment = @post.comments.new
      respond_to do |format|
        format.html { redirect_to @post }
        format.js
        format.json { render json: @comment }
      end
    else
      @new_comment = @comment
      error = @comment.errors[:body]
      flash.now[:danger] = "#{error.count} error(s) prohibited this comment from being saved: #{error.join(", ")}"
      respond_to do |format|
        format.html { render @post }
        format.js { render action: 'failed_save'}
        format.json { render json: error, comment: :unprocessable_entity }
      end
    end
  end

  def edit
    @post        = Post.find(params[:post_id])
    @comment     = @post.comments.find(params[:id])
    @new_comment = @comment

    respond_to do |format|
      format.html { redirect_to @post }
      format.js
      format.json { render json: @comment }
    end
  end

  def update
    @post     = Post.find(params[:post_id])
    @comments = @post.comments
    @comment  = @comments.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(comment_params) && @comment.user == current_user
        format.html { redirect_to @post }
        format.js
        format.json { render json: @comment }
      else
        format.html { redirect_to @post }
        format.js   { render action: 'failed_save'}
        format.json { render json: @comment.errors, comment: :unprocessable_entity }
      end
    end
  end

  def show
    @post     = Post.includes(:user, comments: [:user, :votes, :replies]).find(params[:post_id])
    @comment  = @post.comments.includes({user: :votes}, :replies).find(params[:id])
    @comments = @post.comments.includes({user: :votes}, :replies)
    @replies  = @comment.replies.page(params[:page])

    respond_to do |format|
      format.html { redirect_to @post }
      format.js
      format.json { render json: @comment, 
        include: [
          :versions,
          :user,
          :votes,
          replies: {
            include: [
              :votes
            ]
          }
        ]
      }
    end

    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { redirect_to @post }
        format.json { render text: "{'404': 'Not Found'}", comment: :unprocessable_entity }
        flash.keep[:danger] = "Sorry, this comment has been deleted or has moved"
      end
  end

  def destroy
    @post     = Post.find(params[:post_id])
    @comments = @post.comments
    @comment  = @comments.find(params[:id])

    respond_to do |format|
      if @comment.destroy
        format.html { redirect_to @post }
        format.js
        format.json { head :no_content }
      else
        format.html { redirect_to @post }
        format.js
        format.json { head :no_content }
      end
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
