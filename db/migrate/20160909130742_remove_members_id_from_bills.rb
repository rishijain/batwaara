class RemoveMembersIdFromBills < ActiveRecord::Migration
  def change
    remove_column :bills, :member_ids
  end
end
