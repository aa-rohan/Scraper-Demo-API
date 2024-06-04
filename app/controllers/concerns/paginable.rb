module Paginable
  extend ActiveSupport::Concern

  def default_per_page
    20
  end

  def page_number
    params.fetch(:page_number, 1).to_i
  end

  def per_page
    params.fetch(:per_page, 20).to_i
  end

  def paginate_offset
    (page_number - 1) * per_page
  end

  def order_by
    params.fetch(:order_by, :id)
  end

  def order_direction
    params.fetch(:order_direction, :asc)
  end

  def paginate
    ->(it) { it.limit(per_page).offset(paginate_offset).order("#{order_by}": order_direction) }
  end
end
