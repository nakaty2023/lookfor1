class AddLonlatToShops < ActiveRecord::Migration[7.0]
  def change
    add_column :shops, :lat, :float
    add_column :shops, :lon, :float
  end
end
