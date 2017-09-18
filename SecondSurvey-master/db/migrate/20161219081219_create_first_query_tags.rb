class CreateFirstQueryTags < ActiveRecord::Migration[5.0]
  def up
    create_table(:first_query_tags, :id => false) do |t|
      t.integer :queryID
      t.integer :shotID
      t.string :tagDesc
      t.integer :tagID
      t.integer :tagScore

      t.timestamps
    end
    
    execute "ALTER TABLE first_query_tags ADD PRIMARY KEY (queryID, shotID, tagDesc);"
    execute "ALTER TABLE first_query_tags ADD constraint fk_queryID_from_first_queries foreign key (queryID) references first_queries (queryID) ON DELETE cascade;"
  end

  def down
    drop_table(:first_query_tags)
  end
end
