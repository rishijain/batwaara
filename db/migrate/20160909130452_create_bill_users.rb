class CreateBillUsers < ActiveRecord::Migration
  def change
    create_table :bill_users do |t|
      t.references :user
      t.references :bill

      t.timestamps null: false
    end
  end
end
