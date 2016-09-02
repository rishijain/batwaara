class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.float :amount_paid
      t.references :user
      t.references :bill

      t.timestamps null: false
    end
  end
end
