class CreateLedgers < ActiveRecord::Migration
  def change
    create_table :ledgers do |t|

      t.references :from_user
      t.references :to_user
      t.float :amount, default: 0

      t.timestamps null: false
    end
  end
end
