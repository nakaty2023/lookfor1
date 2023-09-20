class CreateExchangeposts < ActiveRecord::Migration[7.0]
  def change
    create_table :exchangeposts do |t|
      t.string :give_item_name
      t.text :give_item_description
      t.string :want_item_name
      t.text :want_item_description
      t.string :place
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :exchangeposts, [:user_id, :created_at]
  end
end
