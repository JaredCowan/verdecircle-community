class ActivitiesController < ApplicationController
  load_and_authorize_resource
  before_filter :authenticate_user!, except: [:index, :show]
  respond_to :html, :json

  def index
    @activities = Activity.all
  end
end
