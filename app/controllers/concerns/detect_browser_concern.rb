module DetectBrowserConcern
  extend ActiveSupport::Concern

  included do
    # Uncomment after layout for mobile is fully setup
    # layout :detect_browser

    if Rails.env == "development"
      before_filter :detect_browser
    end
  end

  private
    # Array for matching user_agent to mobile device definitions
    MOBILE_BROWSERS = %w(iphone ipad android ipod opera mini blackberry palm hiptop avantgo plucker xiino blazer elaine windows\ ce;\ ppc; windows\ ce;\ smartphone; windows\ ce;\ iemobile up.browser up.link mmp symbian smartphone midp wap vodafone o2 pocket kindle mobile pda psp treo)

    def detect_browser
      # Assign user_agent
      agent = request.headers["HTTP_USER_AGENT"].downcase

      # Default layout
      @agent_view = "application"

      # Check for user_agent match in MOBILE_BROWSERS array
      # 
      # Reassigns @agent_view to mobile if match is found. Otherwise, desktop
      MOBILE_BROWSERS.each do |m|
        if agent.match(m)
          @agent_view = "mobile"
        end
      end

      # Assign default if @agent_view is still not defined
      @agent_view ||= "application"

      # Just for testing
      case @agent_view
        when "mobile"
          test = "mobile"
        else
          test = "desktop"
      end
      5.times { puts "You're using a #{test} device" }
      # End testing

      case @agent_view
        when "mobile"
          return "mobile"
        else
          return "application"
      end
    end
  # End Private Methods
end
