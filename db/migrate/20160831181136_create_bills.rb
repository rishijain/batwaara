class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|

      t.float :amount
      t.references :event
      t.references :paid_to
      t.string :aasm_state
      t.text :member_ids, array: true, default: []

      t.timestamps null: false
    end
  end
end
