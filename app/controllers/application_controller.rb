class ApplicationController < ActionController::Base
  # if ENV['BASIC_AUTH']
  #   user, pass = ENV['BASIC_AUTH'].split(':')
  #   http_basic_authenticate_with name: user, password: pass
  # end

  if Rails.env == "production"
    rescue_from Exception, :with => :render_500
    rescue_from NoMethodError, :with => :render_not_found
  end

  # rescue_from ActionController::RoutingError, :with => :render_not_found
  # rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
  # rescue_from Exception, :with => :render_404

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Devise, require authenticate by default
  before_filter :authenticate_user!
  # before_filter :build_url

  # CanCan, check authorization unless authorizing with devise
  check_authorization unless: :skip_check_authorization?

  # Special handling for ajax requests.
  # Must appear before other rescue_from statements.
  rescue_from Exception, with: :handle_uncaught_exception

  include CommonHelper
  include ErrorReportingConcern
  include AuthorizationErrorsConcern
  include DetectBrowserConcern

  # Move flyer method to helper.
  def flyer(style = "notice", options = {})
    options.key?(:value)  ? "" : options.merge!(:value  => I18n.t('gflash.errors.nodefault'))
    options.key?(:sticky) ? "" : options.merge!(:sticky => true)
    options.key?(:time)   ? "" : options.merge!(:time => 2000)
    options.key?(:title)  ? "" : options.merge!(:title => I18n.t("#{style}", :scope => [:gflash, :titles]))
    imagePath = options.values_at(:image).to_s.gsub("nil", "").delete("[\"]")
    options.merge!(:image => "#{imagePath}") if options.key?(:image)

    defaultClass = "#{style}"
    puts options.key?(:class)
    userClass    = options.key?(:class) ? options.values_at(:class) : nil
    newClass     = "#{defaultClass} #{userClass}".gsub("nil", "").delete("[\"]")

    options.merge!(:class_name => "#{newClass}")

    case style
      when "notice"
        gflash notice: options
      when "error"
        gflash error: options
      when "success"
        gflash success: options
      when "warning"
        gflash warning: options
      when "progress"
        gflash progress: options
      else
        gflash notice: options
    end

    puts options
  end

  # def build_url
  #   session[:return_to] = request.env["HTTP_REFERER"] unless request.env["HTTP_REFERER"].blank?
  #   request.env['QUERY_STRING'] = add_to_url(request.env['REQUEST_URI'], return_to: session[:return_to])
  # end

  protected

    def skip_check_authorization?
      devise_controller? || is_a?(RailsAdmin::ApplicationController)
    end

    # Reset response so redirect or render can be called again.
    # This is an undocumented hack but it works.
    def reset_response
      self.instance_variable_set(:@_response_body, nil)
    end

    # Respond to uncaught exceptions with friendly error message during ajax requets
    def handle_uncaught_exception(exception)
      if request.format == :js
        report_error(exception)
        flash.now[:error] = Rails.env.development? ? exception.message : I18n.t('errors.unknown')
        render 'layouts/uncaught_error.js'
      else
        raise
      end
    end

    def routing_error
      raise ActionController::RoutingError.new(params[:path])
    end

    def render_not_found
      render "public/404"
    end
  # End Protected Methods

  private

    def render_404(exception = nil)
      logger.info "Exception, redirecting: #{exception.message}" if exception
      redirect_to :root
    end
  # End Private Methods
end

class String
  def is_number?
    true if Float(self) rescue false
  end
end
