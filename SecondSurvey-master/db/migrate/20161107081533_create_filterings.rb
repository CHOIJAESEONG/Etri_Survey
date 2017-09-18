class CreateFilterings < ActiveRecord::Migration[5.0]
  def up
    create_table(:filterings, :id => false) do |t|
      t.string :sUserID
      t.string :serviceProvider
      t.string :degree
      t.string :price
    end
  
    execute "ALTER TABLE filterings ADD PRIMARY KEY (sUserID);"
    execute "ALTER TABLE filterings ADD constraint fk_sUserID_from_users foreign key (sUserID) references users (sUserID) ON DELETE cascade;"
  end
  
  def down
    drop_table(:filterings)
  end
end
