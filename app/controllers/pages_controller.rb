class PagesController < ApplicationController
  skip_authorization_check
  skip_before_action :authenticate_user!

  def home
    @posts = Post.includes(:votes, :comments, :tags, :topic, :favorites, {user: :votes}).order(:created_at).page(params[:page]).decorate
    redirect_to posts_path # if user_signed_in?
  end

  # Static views for main verdecircle.com - Blog & Contact have their own model.
  def index
    render "index", layout: "verdecircle"
  end

  def pricing
    render "pricing", layout: "verdecircle"
  end

  def thriii
    render "thriii", layout: "verdecircle"
  end

  def show_startups_pricing
    respond_to do |format|
      format.html { redirect_to "/pricing" }
      format.js { render "pages/pricing/show_startups_pricing", layout: false }
    end
  end

  def hide_startups_pricing
    respond_to do |format|
      format.html { redirect_to "/pricing" }
      format.js { render "pages/pricing/hide_startups_pricing", layout: false }
    end
  end

  # Preview html email template
  def email
    template = (params[:layout] || 'email').to_sym
    # template = :hero unless [:email, :hero, :simple, :new].include? template
    file = 'user_mailer/welcome_email'
    @user = (defined?(FactoryGirl) \
      ? User.new( FactoryGirl.attributes_for :user )
      : User.new( email: 'test@example.com', first_name: 'John', last_name: 'Smith' ))
    render file, layout: "emails/#{template}"
    if params[:premail] == 'true'
      puts "\n!!! USING PREMAILER !!!\n\n"
      pre = Premailer.new(response_body[0],  warn_level: Premailer::Warnings::SAFE, with_html_string: true)
      reset_response
      # pre.warnings
      render text: pre.to_inline_css, layout: false
    end
  end

  def test
    render "test", layout: "mobile"
  end

  def tags
    if params[:q] && !params[:q].empty?
      tagArray = []
      q        = ActionController::Base.helpers.strip_tags(params[:q]).downcase.parameterize
      Tag.all.each { |t| tagArray.push(t) if (t.name[0].include?(q[0]) && t.name[1..-1].include?(q[1..-1])) }
      @tags = tagArray
    else
      @tags = Tag.limit(20)
    end

    respond_to do |format|
      format.json { render json: @tags }
    end
  end

  def error
    redirect_to root_path if flash.empty?
  end

  def ajax
    @msgType = params[:unread] == "false" ? "read" : "unread"
    @user  = current_user
    @notifications = @user.send(params[:get]).send(@msgType)
    @notifications.length < 1 ? @notifications = "You have no #{@msgType.capitalize} notifications" : ""
    respond_to do |format|
      format.json { render json: @notifications }
    end
    10.times { puts params }
  end
end
