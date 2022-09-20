class UserOrderController < ApplicationController
  before_action :authenticate_user!
  def create
    @current_busket = session[current_user.id]

    @lots = []

    if @current_busket.nil?
      @current_busket = []
    end

    @current_busket.each do |elem|
      lot = Post.find(elem["lot_id"])
      lot.in_busket_count = elem["count"]
      lot.total_cost = lot.in_busket_count * lot.cost
      @lots << lot
    end

    @lots.each do |lot|
      @post = Post.find(lot.id)

      if @post.count < lot.in_busket_count
        lot.in_busket_count = @post.count
        @post.count = 0
        @post.save!
      else
        @post.count -= lot.in_busket_count
        @post.save!
      end

      UserOrder.new(post_id: lot.id, user_id: current_user.id,
                    total_cost: lot.total_cost, count: lot.in_busket_count).save
    end

    session.delete(current_user.id)

    redirect_to show_user_order_path()
  end

  def show
    @orders = UserOrder.where(user_id: current_user.id, status: UserOrder.statuses[:active]).to_a
    @total_cost = @orders.inject(0) { |sum, order| sum += order.total_cost }
  end

  def destroy
    @lot = UserOrder.find(params[:id])
    @lot.destroy

    redirect_to show_user_order_path()
  end
end
