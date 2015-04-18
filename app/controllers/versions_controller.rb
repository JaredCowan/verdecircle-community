class VersionsController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_user!

  # Revert a post or comment to a previous version before or after being edited
  def revert
    @version = PaperTrail::Version.find(params[:id])
    if @version.reify
      @version.reify.save!
    else
      @version.item.destroy
    end
    link_name = params[:redo] == "true" ? "undo" : "redo"
    link = view_context.link_to(link_name, revert_version_path(@version.next, :redo => !params[:redo]), class: "btn btn-warning", :method => :post)
    redirect_to :back, :notice => "Undid #{@version.event}. #{link}".html_safe
  end

  def restore_all_post
    Post.deleted.each do |p|
      Post.restore(p.id, :recursive => true)
    end
    flash.keep[:success] = "All posts have been restored and are now public again."
    redirectPath = request.env["HTTP_REFERER"] ||= posts_path
    redirect_to redirectPath
  end

  def restore_all_comment
    d = 0
    s = 0
    Comment.deleted.each do |p|
      d += 1
      if !Post.with_deleted.find(p.post_id).deleted?
        Comment.restore(p.id, :recursive => true)
        s = d - 1
      end
    end
    result = d - s
    commentsLeft = "<br>Some comments need their parent post restored, before comments can be." if s < result
    flash.keep[:success] = "#{s} out of #{result} eligible comments have been restored and are now public again. #{commentsLeft} You may not be the creator of post.".html_safe
    redirectPath = request.env["HTTP_REFERER"] ||= posts_path
    redirect_to redirectPath
  end

  # Restore a post that has been deleted.
  # 
  # Recursive restores all their dependently destroyed associated records. (I.E. Comments, likes etc.)
  def restore_post
    Post.restore(params[:id], :recursive => true)
    flash.keep[:success] = "Post was restored and is now public again. You can view post here: <a href=\"#{post_path(params[:id])}\">Restored Post</a>".html_safe
    redirectPath = request.env["HTTP_REFERER"] ||= posts_path
    redirect_to redirectPath
  end

  def super_delete_post
    post = Post.with_deleted.find(params[:id])
    post.really_destroy!
    flash.keep[:success] = "Post was permanently deleted."
    redirectPath = request.env["HTTP_REFERER"] ||= posts_path
    redirect_to redirectPath
  end

  # Restore a comment that has been deleted.
  # 
  # Recursive restores all their dependently destroyed associated records. (I.E. Comments, likes etc.)
  def restore_comment
    Comment.restore(params[:id], :recursive => true)
    flash.keep[:success] = "Post was restored and is now public again. You can view post here: <a href=\"#{post_path(params[:id])}\">Restored Post</a>".html_safe
    redirectPath = request.env["HTTP_REFERER"] ||= posts_path
    redirect_to redirectPath
  end

  def super_delete_comment
    comment = Comment.with_deleted.find(params[:id])
    comment.really_destroy!
    flash.keep[:success] = "Comment was permanently deleted."
    redirectPath = request.env["HTTP_REFERER"] ||= posts_path
    redirect_to redirectPath
  end

  def super_delete_all_comments
    Comment.deleted.each do |c|
      c.really_destroy!
    end
    flash.keep[:success] = "All soft deleted comments were permanently deleted."
    redirectPath = request.env["HTTP_REFERER"] ||= posts_path
    redirect_to redirectPath
  end
end
