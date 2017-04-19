class CreatePics < ActiveRecord::Migration[5.0]
  def change
    create_table :pics do |t|
      t.integer :product_id, index: true
      t.text :name

      t.timestamps null: false
    end
    add_foreign_key :pics, :products
  end
end
