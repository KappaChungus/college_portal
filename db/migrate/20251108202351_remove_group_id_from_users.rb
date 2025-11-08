class RemoveGroupIdFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :group_id, :integer
  end
end
