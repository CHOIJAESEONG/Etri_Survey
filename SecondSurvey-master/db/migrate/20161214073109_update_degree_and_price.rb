class UpdateDegreeAndPrice < ActiveRecord::Migration[5.0]
  def up
    change_column :filterings, :degree, :integer
    change_column :filterings, :price, :integer
  end
  
  def down
    change_column :filterings, :degree, :string
    change_column :filterings, :price, :string
  end
end
