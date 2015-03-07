class PostDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  decorates_finders
  delegate_all

  # def prettyname
  #   model.username.titleize
  # end

  # def decoratetime
  #   case model.created_at.today? ? "today" : (model.created_at < 1.day.ago ? "yesterday" : "older")
  #     when "today"
  #       model.created_at.strftime("Today at %l:%M%P")
  #     when "yesterday"
  #       model.created_at.strftime("Yesterday at %l:%M%P")
  #     when "older"
  #       model.created_at.strftime("Posted %a, %b %d at %l:%M%P")
  #     else
  #       model.created_at.strftime("Posted %a, %b %d at %l:%M%P")
  #   end
  # end
end
