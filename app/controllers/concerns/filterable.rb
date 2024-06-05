module Filterable
  extend ActiveSupport::Concern

  def filter(collection)
    collection = collection.filter_by_category(params[:category]) if params[:category]
    collection
    # collection.filter_by_price_range(params.fetch(:min_price, 0), params.fetch(:max_price, Float::INFINITY)) IMPLEMENT LATER
  end
end
