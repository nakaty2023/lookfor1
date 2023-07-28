class CreateMunicipalities < ActiveRecord::Migration[7.0]
  def change
    create_table :municipalities do |t|
      t.integer :number
      t.string :name
      t.integer :pref_id

      t.timestamps
    end
  end
end
