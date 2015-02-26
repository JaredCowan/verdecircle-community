class UserDecorator < Draper::Decorator
  include Draper::LazyHelpers
  delegate_all

  def created
    object.created_at.strftime("%a %m/%d/%y")
  end

  def username
    object.username.titleize
  end

  def first_name
    object.first_name.titleize
  end

  def last_name
    object.last_name.titleize
  end
  
  def fullname
    o = object
    "Full Name: #{o.first_name} #{o.last_name}"
  end
end
