class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users, id: false do |t|
      t.string :sUserID, null: false, limit: 20
      t.string :name, limit: 20

      t.timestamps
    end
    
    execute "ALTER TABLE users ADD PRIMARY KEY (sUserID);"
  end
end
