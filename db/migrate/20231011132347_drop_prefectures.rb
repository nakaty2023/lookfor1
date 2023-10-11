class DropPrefectures < ActiveRecord::Migration[7.0]
  def change
    drop_table :prefectures
  end
end
