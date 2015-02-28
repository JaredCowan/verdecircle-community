class ActivitiesController < ApplicationController
  # skip_authorization_check
  load_and_authorize_resource
  before_filter :authenticate_user!, except: [:index, :show]
  respond_to :html, :json

  def index
    @activities = Activity.all.order("created_at DESC")
  end
end
