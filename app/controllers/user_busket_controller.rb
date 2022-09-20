class UserBusketController < ApplicationController
  #load_and_authorize_resource
  before_action :authenticate_user!
=begin
{
  "lot_id": 15,
  "count": 15
}
=end
  def create
    @post = Post.find(busket_params[:lot_id])

    if !session[current_user.id].kind_of?(Array)
      session[current_user.id] = []
    end

    current_lot = session[current_user.id].find { |elem| elem["lot_id"] == @post.id }

    if current_lot.nil?
      current_lot = { lot_id: busket_params[:lot_id], count: busket_params[:count] }
      session[current_user.id] << current_lot
    else
      current_lot["count"] += busket_params[:count]
      if current_lot["count"] <= 0
        session[:current_lot].delete_if { |lot| lot == @post.id }
      end
    end

    respond_to do |format|
      if true
        format.json { render json: { user_busket: :session[current_user.id], result: "Готово!" }.to_json, status: :created, location: @post }
      else
        format.json { render json: { result: "Что-то пошло не так..." }, status: :unprocessable_entity }
      end
    end
  end

  def show
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

    @full_order_cost = @lots.inject(0) { |sum, elem| sum += elem.total_cost }
  end

  def destroy
    session.delete(current_user.id)

    respond_to do |format|
      if true
        format.html { redirect_to show_busket_path }
        format.json { render json: { result: "Корзина очищена!" }, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def busket_params
    params.permit(:count, :lot_id)
  end
end
