class CreateUserOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :user_orders do |t|
      t.references :post
      t.references :user
      t.bigint :count
      t.bigint :total_cost
      t.bigint :status, default: 0

      t.timestamps
    end
  end
end
