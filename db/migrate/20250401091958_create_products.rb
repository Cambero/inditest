class CreateProducts < ActiveRecord::Migration[7.2]
  def up
    create_enum :product_category, %w[clothing electronics books beauty]

    create_table :products do |t|
      t.string :name, null: false
      t.string :code, limit: 10, null: false
      t.text :description
      t.enum :category, enum_type: "product_category", null: false
      t.decimal :price, null: false
      t.integer :units, default: 0
      t.string :images, array: true, default: []
      t.integer :users_score
      t.integer :sold_units, default: 0
      t.string :location
      t.decimal :real_price

      t.belongs_to :created_by
      t.belongs_to :updated_by
      t.timestamps
    end
    add_index :products, :code, unique: true
  end

  def down
    drop_table :products
  end
end
