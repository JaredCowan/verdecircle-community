class BlogsController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_user!, except: [:index, :show]
  respond_to :html, :json
  layout "verdecircle" # Layout used only for verdecircle.com frontend / sales site

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def index
    @blogs = Blog.includes(:user).page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @blogs, include: [:user] }
    end
  end

  def show
    @blog = Blog.includes(:user).find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @blog, include: [:user] }
    end
  end

  def new
    @blog = Blog.new
  end

  def edit
    @blog = Blog.find(params[:id])
  end

  def create
    @blog = current_user.blogs.new(blog_params)

    respond_to do |format|
      if @blog.save
        format.html { redirect_to @blog }
        format.json { render json: @blog, blog: :created, location: @blog }
        flash[:success] = "Blog was successfully created."
      else
        format.html { render :new }
        format.json { render json: @blog.errors, blog: :unprocessable_entity }
        flash.now[:danger] = "#{@blog.errors.count} error(s) prohibited this blog from being saved: #{@blog.errors.full_messages.join(', ')}"
      end
    end
  end

  def update
    @blog = Blog.find(params[:id])

    @blog.transaction do
      @blog.update_attributes(blog_params)
      unless @blog.valid? || (@blog.valid? && @blog.image && !@blog.image.valid?)
        raise ActiveRecord::Rollback
      end
    end

    respond_to do |format|
      format.html { redirect_to @blog, notice: 'Blog was successfully updated.' }
      format.json { head :no_content }
    end

    rescue ActiveRecord::Rollback

    respond_to do |format|
      format.html do
        flash.now[:error] = "Update failed."
        render action: "edit"
      end
      format.json { render json: @blog.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    @blog = Blog.find(params[:id])

    respond_to do |format|
      if @blog.destroy
        format.html { redirect_to blogs_path }
        format.json { head :no_content }
        flash[:success] = "Blog was successfully deleted."
      else
        flash.keep[:success] = "There was an error deleting this blog."
        redirect_to not_found
      end
    end
  end

  def not_found
    flash.keep[:danger] = "Sorry, we couldn't find that blog you were looking for."
    redirect_to controller: "blogs", action: "index"
  end

  private

  def blog_params
    params.require(:blog).permit(:subject, :body, :image, :image_delete, :tag_list)
  end
end