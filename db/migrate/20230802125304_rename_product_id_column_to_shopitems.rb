class RenameProductIdColumnToShopitems < ActiveRecord::Migration[7.0]
  def change
    rename_column :shopitems, :product_id, :item_id
  end
end
