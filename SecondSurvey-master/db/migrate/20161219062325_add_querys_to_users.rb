class AddQuerysToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :querys, :integer
  end
end
