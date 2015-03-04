class ApplicationDecorator < Draper::Decorator

  # Tell application decorator where to find the workaround for Kaminari
  # 
  # https://github.com/drapergem/draper/issues/401
  def self.collection_decorator_class
    PaginatingDecorator
  end
end
