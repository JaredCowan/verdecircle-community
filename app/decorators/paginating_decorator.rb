class PaginatingDecorator < Draper::CollectionDecorator

  # Workaround for Kaminari
  # 
  # https://github.com/drapergem/draper/issues/401
  delegate :current_page, :total_pages, :limit_value, :last_page?, :next_page
end
