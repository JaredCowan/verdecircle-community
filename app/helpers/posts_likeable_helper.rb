module PostsLikeableHelper
  # def likeLogic(object)

  #   isLiked    = current_user.voted_up_on?(object) ? "unlike" : "like"
  #   isDisliked = current_user.voted_down_on?(object) ? "undisliked" : "disliked"

  #   return I18n.t("#{isLiked}", scope: [:likable, :posts]) + " / " + I18n.t("#{isDisliked}", scope: [:likable, :posts]) 
  # end

  # def hidden_logic(object)
  #   like    = current_user.voted_up_on?(object) ? false : true
  #   dislike = current_user.voted_down_on?(object) ? false : true
  #   return {like: like, dislike: dislike}
  # end

  def query_votes(object)
    # @votes = ActsAsVotable::Vote.where("votable_type = ? AND voter_id = ?", "#{object.class.name}", current_user.id).select(:id, :votable_id, :voter_id, :vote_flag).map(&:votable_id).include?(object.id)
    # @votes = object.votes(Post)
    @votes = object.comments.votes(object).select(:id, :votable_id, :vote_scope).map(&:votable_id)
  end

  def vote_logic_helper(object)
    has_voted = @likes.include?(object.id)

    case has_voted
      when true
        content_tag_for(:div, object, :like) do
          content_tag(:div,
            content_tag(:a, content_tag(:i, " " + I18n.t("likable.posts.like"), class: "fa fa-thumbs-up"), href: like_post_comment_path(@post.id, object.id), data: { method: :put }, class: "btn btn-primary") +
            content_tag(:a, content_tag(:i, " " + I18n.t("likable.posts.disliked"), class: "fa fa-thumbs-down"), href: dislike_post_comment_path(@post.id, object.id), data: { method: :put }, class: "btn btn-primary"),
            class: "btn btn-group"
          )
        end
      when false
        return content_tag_for(:div, object, :like) do
          content_tag(:a, content_tag(:i, I18n.t("likable.posts.like"), class: "fa fa-thumbs-up"),
            href: like_post_comment_path(@post.id, object.id), data: { method: :put }, class: "btn btn-primary")
        end
      else
        flash.now[:danger] = "Sorry there was an error"
    end
  end

  # def airdog
  #   # like = Post.find_by_sql("SELECT posts.id, votes.vote_flag, votes.voter_id FROM posts, votes WHERE votes.voter_id = 3 AND vote_flag = true")
  #   # like = ActsAsVotable::Vote.find_by_sql("SELECT votes.id, votes.votable_id, votes.votable_type, votes.vote_flag, votes.voter_id FROM votes WHERE votes.voter_id = 3 AND vote_flag = true AND votes.votable_id IN ('" + postId.to_s + "')")
  #   like = ActsAsVotable::Vote.find_by_sql("SELECT votes.id, votes.votable_id, votes.votable_type, votes.vote_flag, votes.voter_id FROM votes WHERE votes.voter_id = " + current_user.id.to_s + " AND vote_flag = true AND votes.votable_type = 'Post'")
  #   dislikes = ActsAsVotable::Vote.find_by_sql("SELECT votes.id, votes.votable_id, votes.votable_type, votes.vote_flag, votes.voter_id FROM votes WHERE votes.voter_id = " + current_user.id.to_s + " AND vote_flag = false AND votes.votable_type = 'Post'")
  #   likes = []
  #   # like.each do |l|
  #   #   likes << [l.votable_id, l.voter_id, l.vote_flag]
  #   # end
  #   return like, dislikes
  # end
end
