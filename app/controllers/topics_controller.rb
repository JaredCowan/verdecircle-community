class TopicsController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_user!

  def index
    @topics = Topic.all
  end

  def show
    @topic = Topic.find_by(params[:name])
    @posts = Post.where(topic: @topic)
  end

  def edit
    @topic = Topic.find_by(params[:name])
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      flash[:success] = 'New topic created.'
      redirect_to topics_path
    else
      render 'topics/new'
    end
  end

  def destroy
    Topic.find_by(params[:name]).destroy
    redirect_to topics_path
  end

  def update
    @topic = Topic.find_by(params[:name])
    if @topic.update_attributes(topic_params)
      flash[:success] = 'Topic name updated.'
      redirect_to topics_path
    else
      render 'topics/edit'
    end
  end

  private

    def topic_params
      params.require(:topic).permit(:name)
    end
end
