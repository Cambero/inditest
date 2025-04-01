class CreateOrders < ActiveRecord::Migration[7.2]
  def up
    create_enum :order_status, %w[pending ordered]

    create_table :orders do |t|
      t.belongs_to :product, null: false
      t.belongs_to :user, null: false
      t.integer :units, null: false
      t.decimal :unit_price, null: false
      t.datetime :expiration_date
      t.datetime :order_date
      t.enum :status, enum_type: "order_status" , null: false

      t.belongs_to :created_by
      t.belongs_to :updated_by
      t.timestamps
    end
  end

  def down
    drop_table :orders
  end
end
