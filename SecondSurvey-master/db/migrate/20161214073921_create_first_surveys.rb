class CreateFirstSurveys < ActiveRecord::Migration[5.0]
  def up
    create_table :first_surveys do |t|
      t.integer :cID
      t.integer :shotID
      t.datetime :timestamp
      t.string :fileName
      t.float :preference
      t.string :reason
      t.string :sUserID, null: false, limit: 20

      t.timestamps
    end
    
    execute "ALTER TABLE first_surveys ADD constraint fk_sUserID_from_users_first foreign key (sUserID) references users (sUserID) ON DELETE cascade;"
    execute "ALTER TABLE first_surveys ADD constraint fk_cID_from_clists_first foreign key (cID) references clists (CID) ON DELETE cascade;"
  end
  
  def down
    drop_table(:first_surveys)
  end
end
