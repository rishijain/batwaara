class AddDefaultValueToTransaction < ActiveRecord::Migration
  def change
    change_column :transactions, :amount_paid, :float, :default => 0.0
  end
end
