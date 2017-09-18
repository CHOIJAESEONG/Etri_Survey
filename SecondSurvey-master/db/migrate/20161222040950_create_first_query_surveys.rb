class CreateFirstQuerySurveys < ActiveRecord::Migration[5.0]
  def up
    create_table(:first_query_surveys, :id => false) do |t|
      t.integer :queryID, :options => 'PRIMARY KEY'
      t.integer :shotID, :options => 'PRIMARY KEY'
      t.integer :totalScore
      t.integer :correct
      t.integer :preference
      t.string :reason
      t.boolean :isSelect

      t.timestamps
    end
    
    execute "ALTER TABLE first_query_surveys ADD PRIMARY KEY (queryID, shotID);"
    execute "ALTER TABLE first_query_surveys ADD constraint fk_queryID_from_first_queries_for_survey foreign key (queryID) references first_queries (queryID) ON DELETE cascade;"
  end
  
  def down
    drop_table(:first_query_surveys)
  end
end
