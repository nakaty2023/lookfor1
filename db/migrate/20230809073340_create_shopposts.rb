class CreateShopposts < ActiveRecord::Migration[7.0]
  def change
    create_table :shopposts do |t|
      t.text :content
      t.references :user, foreign_key: true
      t.references :shop, null: false, foreign_key: true

      t.timestamps
    end
    add_index :shopposts, [:user_id, :created_at]
    add_index :shopposts, [:shop_id, :created_at]
  end
end
