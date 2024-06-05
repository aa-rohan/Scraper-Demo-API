class CategoriesController < ApplicationController
  def index
    categories = Category.all
    categories = categories.search(params[:search]) if params[:search]
    render json: categories
  end
end
