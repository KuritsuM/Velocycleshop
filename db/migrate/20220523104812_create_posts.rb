class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.bigint :count
      t.float :cost

      t.timestamps
    end
  end
end
