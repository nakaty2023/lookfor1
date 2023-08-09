class CreateShopitems < ActiveRecord::Migration[7.0]
  def change
    create_table :shopitems do |t|
      t.integer :shop_id
      t.integer :product_id

      t.timestamps
    end
  end
end
