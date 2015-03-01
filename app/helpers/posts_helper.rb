module PostsHelper
  include PostsLikeableHelper
  
  def prettytitle(object, options = {class: "post-header-subject"})
    subject = object.subject.titleize
    return content_tag(:span, subject, options)
  end

  def prettyname(object, options = {})
    username = object.user.username.titleize
    image    = object.user.image_url
    url      = "/u/#{username.downcase}"
    return content_tag(:span,
             content_tag(:a,
               content_tag(:img,
                 content_tag(:span, "@#{username}", class: "post-header-username"),
               src: image, class: "post-header-useravatar"),
             href: url, class: "post-header-userlink"),
           options)
  end

  def prettycreated(object, options = {})
    # time, present, past = object.created_at, "Posted at %l:%H %P", "Posted on %a, %B #{object.created_at.day.ordinalize} at %l:%H %P"
    # formatted_time = time.today? ? time.strftime("#{present}") : time.strftime("#{past}")
    # return content_tag(:span, formatted_time, options)
  end
end
