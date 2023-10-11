class DropMunicipalities < ActiveRecord::Migration[7.0]
  def change
    drop_table :municipalities
  end
end
