module PostsLikeableHelper
  def likeLogic(object)

    isLiked    = current_user.voted_up_on?(object) ? "unlike" : "like"
    isDisliked = current_user.voted_down_on?(object) ? "undisliked" : "disliked"

    return I18n.t("#{isLiked}", scope: [:likable, :posts]) + " / " + I18n.t("#{isDisliked}", scope: [:likable, :posts]) 
  end

  def hidden_logic(object)
    like    = current_user.voted_up_on?(object) ? false : true
    dislike = current_user.voted_down_on?(object) ? false : true
    return {like: like, dislike: dislike}
  end

  def test_logic(object)
    # @votes = ActsAsVotable::Vote.where("votable_type = ? AND voter_id = ?", "#{object.class.name}", current_user.id).select(:id, :votable_id, :voter_id, :vote_flag).map(&:votable_id).include?(object.id)
    @votes = object.votes(Post)
  end

  def airdog
    # like = Post.find_by_sql("SELECT posts.id, votes.vote_flag, votes.voter_id FROM posts, votes WHERE votes.voter_id = 3 AND vote_flag = true")
    # like = ActsAsVotable::Vote.find_by_sql("SELECT votes.id, votes.votable_id, votes.votable_type, votes.vote_flag, votes.voter_id FROM votes WHERE votes.voter_id = 3 AND vote_flag = true AND votes.votable_id IN ('" + postId.to_s + "')")
    like = ActsAsVotable::Vote.find_by_sql("SELECT votes.id, votes.votable_id, votes.votable_type, votes.vote_flag, votes.voter_id FROM votes WHERE votes.voter_id = " + current_user.id.to_s + " AND vote_flag = true AND votes.votable_type = 'Post'")
    dislikes = ActsAsVotable::Vote.find_by_sql("SELECT votes.id, votes.votable_id, votes.votable_type, votes.vote_flag, votes.voter_id FROM votes WHERE votes.voter_id = " + current_user.id.to_s + " AND vote_flag = false AND votes.votable_type = 'Post'")
    likes = []
    # like.each do |l|
    #   likes << [l.votable_id, l.voter_id, l.vote_flag]
    # end
    return like, dislikes
  end
end
