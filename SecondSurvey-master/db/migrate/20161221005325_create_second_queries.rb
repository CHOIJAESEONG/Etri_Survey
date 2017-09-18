class CreateSecondQueries < ActiveRecord::Migration[5.0]
  def up
    create_table(:second_queries, :id => false) do |t|
      t.integer :queryID, :options => 'PRIMARY KEY'
      t.string :sUserID
      t.string :query

      t.timestamps
    end
    
    execute "ALTER TABLE second_queries ADD PRIMARY KEY (queryID);"
    execute "ALTER TABLE second_queries modify column queryID int(11) auto_increment;"
    execute "ALTER TABLE second_queries ADD constraint fk_sUserID_from_users_for_second_queries foreign key (sUserID) references users (sUserID) ON DELETE cascade;"
  end
  
  def down
    drop_table(:second_queries)
  end
end
