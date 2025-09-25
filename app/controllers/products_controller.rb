class ProductsController < ApplicationController
  def new; end

  def edit
    @product = Product.find(params[:id]).as_json(include: { modifier_groups: { include: :modifiers } })
  end
end
