class CreateMaxQueries < ActiveRecord::Migration[5.0]
  def up
    create_table :max_queries do |t|
      t.integer :max
    end
  end
  
  def down
    drop_table(:max_queries)
  end
end
