class FavoritesController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_user!

  def index
    @favorites = current_user.favorites
  end

  def add_favorite
    klass    = params[:className].constantize.to_s
    userId   = current_user.id
    objectId = params[:id]

    Favorite.create(user_id: userId,
                    favorable_id: objectId,
                    favorable_type: klass,
    )

    Activity.create(user_id: userId,
                    action: "favorited",
                    targetable_id: objectId,
                    targetable_type: klass
    ) # End Create Activity

    flash.keep[:success] = "Added to your favorites!"
    redirect_to :back
  end

  def remove_favorite
    klass    = params[:className].constantize.to_s
    objectId = params[:id]

    current_user.activities.where("targetable_id = ? AND targetable_type = ?", objectId, klass).first.destroy!
    current_user.favorites.where("favorable_id = ? AND favorable_type = ?", objectId, klass).first.destroy!

    flash.keep[:success] = "Removed from favorites!"
    redirect_to :back
  end
end
