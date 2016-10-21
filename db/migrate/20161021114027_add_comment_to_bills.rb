class AddCommentToBills < ActiveRecord::Migration
  def change
    add_column :bills, :comment, :string
  end
end
