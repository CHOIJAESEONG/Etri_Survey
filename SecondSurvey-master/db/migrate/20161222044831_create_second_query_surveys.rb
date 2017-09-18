class CreateSecondQuerySurveys < ActiveRecord::Migration[5.0]
  def up
    create_table(:second_query_surveys, :id => false) do |t|
      t.integer :queryID, :options => 'PRIMARY KEY'
      t.integer :shotID, :options => 'PRIMARY KEY'
      t.integer :firstQueryID
      t.integer :totalScore
      t.integer :correct
      t.integer :similarity
      t.integer :preference
      t.string :reason
      t.boolean :isSelect
  
      t.timestamps
    end
    
    execute "ALTER TABLE second_query_surveys ADD PRIMARY KEY (queryID, shotID);"
    execute "ALTER TABLE second_query_surveys ADD constraint fk_queryID_from_second_queries_for_survey foreign key (queryID) references second_queries (queryID) ON DELETE cascade;"
    execute "ALTER TABLE second_query_surveys ADD constraint fk_firstQueryID_from_first_queries_for_survey foreign key (firstQueryID) references first_queries (queryID) ON DELETE cascade;"
  end
  
  def down
    drop_table(:second_query_surveys)
  end
end
