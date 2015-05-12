module VotableConcern
  extend ActiveSupport::Concern

  included do
    before_filter :render_action
  end

  WHITELIST_ACTIONS = %w(liked unliked disliked undisliked)

  def render_action
    @action = params[:action]

    if WHITELIST_ACTIONS.include?(@action)
      @klass  = params[:controller].classify.constantize
      @id     = params[:id]
      @object = @klass.find(@id)

      20.times { puts params }
      case @action
      when "liked"
        liked(@object, @id, @klass, @action)
      when "unliked"
        unliked(@object, @id, @klass, @action)
      when "disliked"
        disliked(@object, @id, @klass, @action)
      when "undisliked"
        undisliked(@object, @id, @klass, @action)
      when "report"
        report(@object, @id, @klass, @action)
      end
    end
  end

  def liked(object, id, klass, action)
    object.liked_by current_user, :vote_weight => 1
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render "posts/vote" }
    end
  end

  def unliked(object, id, klass, action)
    object.unliked_by current_user, :vote_weight => 1
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render "posts/vote" }
    end
  end

  def disliked(object, id, klass, action)
    # current_user.create_activity(object, 'disliked')
    object.disliked_by current_user, :vote_weight => 1
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render "posts/vote" }
    end
  end

  def undisliked(object, id, klass, action)
    # @activity = Activity.where("targetable_id = ?", object.id)
    # @activity.destroy
    object.undisliked_by current_user, :vote_weight => 1
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render "posts/vote" }
    end
  end

  def report(object, id, klass, action)
    object.disliked_by current_user, vote_scope: "reported"
    redirect_to :back
  end
end