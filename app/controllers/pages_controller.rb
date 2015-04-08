class PagesController < ApplicationController
  skip_authorization_check
  skip_before_action :authenticate_user!

  def home
    @posts = Post.includes(:votes, :comments, :tags, :topic, :favorites, {user: :votes}).order(:created_at).page(params[:page]).decorate
    redirect_to posts_path if user_signed_in?
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

  # Preview html email template
  def email
    tpl = (params[:layout] || 'hero').to_sym
    tpl = :hero unless [:email, :hero, :simple, :new].include? tpl
    file = 'user_mailer/welcome_email'
    @user = (defined?(FactoryGirl) \
      ? User.new( FactoryGirl.attributes_for :user )
      : User.new( email: 'test@example.com', first_name: 'John', last_name: 'Smith' ))
    render file, layout: "emails/#{tpl}"
    if params[:premail] == 'true'
      puts "\n!!! USING PREMAILER !!!\n\n"
      pre = Premailer.new(response_body[0],  warn_level: Premailer::Warnings::SAFE, with_html_string: true)
      reset_response
      # pre.warnings
      render text: pre.to_inline_css, layout: false
    end
  end

  def error
    redirect_to root_path if flash.empty?
  end

  def ajax
    respond_to do |format|
      format.json { render json: {link: "<li role='presentation'> <a role='menuitem' tabindex='-1' href='<%= url_for report_path(post) %>'>Wrong Category</a> </li> <li role='presentation'> <a role='menuitem' tabindex='-1' href='<%= url_for report_path(post) %>'>It's Spam</a> </li> <li role='presentation'> <a role='menuitem' tabindex='-1' href='<%= url_for report_path(post) %>'>Content Is Pointless</a> </li> <li role='presentation'> <a role='menuitem' tabindex='-1' href='<%= url_for report_path(post) %>'>I Don't Like It</a> </li> <li role='presentation'> <a role='menuitem' tabindex='-1' href='<%= url_for report_path(post) %>'>Other</a> </li>"} }
    end
  end
end
