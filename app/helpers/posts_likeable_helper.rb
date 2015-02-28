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
end
