class TopicsController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_user!

  def index
    @topics = Topic.includes(posts: [{topic: :posts}, :user])
  end

  def show
    @topic = Topic.includes(posts: [{topic: :posts}, :user]).find_by_name(params[:id])
    @posts = Topic.includes(posts: [{comments: :user}, :user, :tags]).find(@topic).posts.where(topic: @topic).page(params[:page])
  end

  def edit
    @topic = Topic.find_by_name(params[:id])
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      flash[:success] = 'New category created.'
      redirect_to topics_path
    else
      render 'topics/new'
    end
  end

  def destroy
    Topic.find_by_name(params[:id]).destroy
    flash[:success] = 'Category has been deleted.'
    redirect_to topics_path
  end

  def update
    @topic = Topic.find_by_name(params[:id])
    if @topic.update_attributes(topic_params)
      flash[:success] = 'Category updated.'
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
