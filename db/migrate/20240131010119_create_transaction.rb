class CreateTransaction < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.integer :transaction_id, index: true
      t.integer :merchant_id
      t.integer :user_id, index: true
      t.string :card_number
      t.datetime :transaction_date
      t.integer :transaction_amount
      t.integer :device_id
      t.boolean :has_cbk
      t.string :recommendation
    end
  end
end
