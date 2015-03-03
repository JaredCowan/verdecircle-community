module ApplicationHelper
  include CommonHelper
  include ConversationHelper

  # Render a partial only one time.
  # Useful for rendering partials that require JavaScript like Google Maps
  # where other views may have also included the partial.
  def render_once(view, *args, &block)
    @_render_once ||= {}
    if @_render_once[view]
      nil
    else
      @_render_once[view] = true
      render(view, *args, &block)
    end
  end

  def brand_name
    return "#{I18n.t('brand.name')}"
  end

  def is_admin?
    if current_user
      current_user.is_admin?
    end
  end

  def username
    current_user.username.titleize
  end

  def email
    current_user.email
  end

  def locales(type)
    %(#{I18n.t "#{type}"})
  end

  def tag_cloud(tags, classes)
    max = tags.sort_by(&:count).last
    tags.each do |tag|
      index = tag.count.to_f / Integer(max.count) * (classes.size - 1)
      yield(tag, classes[index.round])
    end
  end

  # To add text in front on the default title. Place this at the head of the view page.
  # <% provide(:title, view_bag_title("your text here")) %>
  # To completely replace the title, just use <% provide(:title, "your text here") %>
  def view_bag_title(*args)
    currentUser = "#{current_user.username.titleize} |" if current_user && !current_user.username.empty?
    default = "#{currentUser} #{I18n.t('brand.name')}"
    args    = args[0]
    if args
      title = "#{args} | #{default}"
    end
    title ||= default
    return "#{title}"
  end
end
