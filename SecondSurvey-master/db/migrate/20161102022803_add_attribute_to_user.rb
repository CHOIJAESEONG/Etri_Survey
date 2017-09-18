class AddAttributeToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :birthday, :date
    add_column :users, :sex, :string, limit: 2
    add_column :users, :married, :string, limit: 2
    add_column :users, :children, :string, limit: 2
    add_column :users, :job, :string, limit: 100
    add_column :users, :hobby, :string, limit: 100
    add_column :users, :currentShot, :integer
  end
end
