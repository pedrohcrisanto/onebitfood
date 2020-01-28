class OrdersController < ApplicationController
  before_validation :set_price
  before_action :set_order, only: :show
  def create
    order = Order.new(order_params)
    if order.save
      render json: @order, status: :created
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @order
  end

   
private
   
def set_order
  @order = Order.find(params[:id])
end
 
def order_params
  params.require(:order).permit(
    :name, :phone_number, :restaurant_id,
    order_products_attributes: %i[quantity comment product_id]
  )
end

def set_price
  @final_price = 0
  order_products.each do |order_product|
    product = Product.find order_product.product_id
    @final_price += order_product.quantity * product.price
  end
   
  self.total_value = @final_price
end
end
