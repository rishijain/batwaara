class AddCreatedByToBills < ActiveRecord::Migration
  def change
    add_reference :bills, :created_by
  end
end
