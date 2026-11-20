class CreatePointTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :point_transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :amount, null: false
      t.string :transaction_type, null: false

      t.timestamps
    end
  end
end