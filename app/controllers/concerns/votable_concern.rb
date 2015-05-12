module VotableConcern
  extend ActiveSupport::Concern

  included do
    before_filter :render_action
  end

  WHITELIST_ACTIONS = %w(liked unliked disliked undisliked).freeze

  def render_action
    @action = params[:action]

    if WHITELIST_ACTIONS.include?(@action)
      @klass  = params[:controller].classify.constantize
      @id     = params[:id]
      @object = @klass.find(@id)

      20.times { puts params }
      case @action
      when "liked"
        liked(@object, @action)
      when "unliked"
        unliked(@object, @action)
      when "disliked"
        disliked(@object, @action)
      when "undisliked"
        undisliked(@object, @action)
      when "report"
        report(@object, @action)
      end
    end
  end

  def liked(object, action)
    object.liked_by current_user, :vote_weight => 1
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render "posts/vote" }
    end
  end

  def unliked(object, action)
    object.unliked_by current_user, :vote_weight => 1
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render "posts/vote" }
    end
  end

  def disliked(object, action)
    # current_user.create_activity(object, 'disliked')
    object.disliked_by current_user, :vote_weight => 1
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render "posts/vote" }
    end
  end

  def undisliked(object, action)
    # @activity = Activity.where("targetable_id = ?", object.id)
    # @activity.destroy
    object.undisliked_by current_user, :vote_weight => 1
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render "posts/vote" }
    end
  end

  def report(object, action)
    object.disliked_by current_user, vote_scope: "reported"
    redirect_to :back
  end
end