class AddScienceTitleToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :science_title, :string
  end
end
