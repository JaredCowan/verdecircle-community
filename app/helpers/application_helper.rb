module ApplicationHelper
  include ActsAsTaggableOn::TagsHelper
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

  def is_desktop?
    return @agent_view == "desktop" ? true : false if defined? @agent_view
  end

  def is_mobile?
    return !is_desktop? if defined? @agent_view
  end

  def brand_name
    return "#{I18n.t('brand.name')}"
  end

  def is_admin?
    if current_user
      current_user.is_admin?
    end
  end

  # Authorize user as owner of object or allow/disallow admin
  def is_owner?(object, no_admin = false)
    if current_user && current_user.id === object.user.id && (object.user.is_admin? || !no_admin)
      return true
    elsif is_admin? && !no_admin
      return true
    else
      return false
    end
  rescue
    return false
  end

  def pluralize_without_count(count, singular, plural = nil)
    if count == 1
      singular
    else
       plural || singular.pluralize
    end
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

  def follow_link_helper(user, options = {})
    if current_user
      iffollowing = current_user.user_relationships.map(&:follower_id).include?(user.id) ? [true, "Unfollow"] : [false, "Follow"]

      if current_user.id == user.id
        default = "disabled"
        given = options[:class]
        merged = options.has_key?(:class) ? "#{given} #{default}" : "btn btn-primary disabled"
        options[:class] = merged
        link_to "#{iffollowing[1]}", "Javascript:;", options
      else
        case iffollowing[0]
          when false
              defaultFollow = {method: :create, data:{follower_id: user.id}}
              options.merge!(defaultFollow)

              link_to "#{iffollowing[1]}", new_user_relationship_path(follower_id: user.id), options
          when true
            defaultUnfollow = {method: :delete}
            options.merge!(defaultUnfollow)

            link_to "#{iffollowing[1]}", user_relationship_path(username: user.username.downcase, id: user.id), options
        end
      end
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
