class FavoritesController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_user!

  def index
    @favorites = current_user.favorites
  end

  def add_favorite
    klass    = params[:className].classify.constantize.to_s
    userId   = current_user.id
    objectId = params[:id]
    @object  = klass.constantize.first

    Favorite.create(user_id: userId,
                    favorable_id: objectId,
                    favorable_type: klass,
    )

    # Activity.create(user_id: userId,
    #                 action: "favorited",
    #                 targetable_id: objectId,
    #                 targetable_type: klass
    # ) # End Create Activity

    gflash success: "Added to your favorites!"

    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render "favorites/render_buttons", layout: false }
    end
  end

  def remove_favorite
    klass    = params[:className].classify.constantize.to_s ||= params[:controller].classify.constantize.to_s
    objectId = params[:id]
    @object  = klass.constantize.first

    # current_user.activities.where("targetable_id = ? AND targetable_type = ?", objectId, klass).first.destroy!
    current_user.favorites.where("favorable_id = ? AND favorable_type = ?", objectId, klass).first.destroy!

    gflash success: "Removed from your favorites!"

    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render "favorites/render_buttons", layout: false }
    end
  end
end
