class CreateClists < ActiveRecord::Migration[5.0]
  def up
    create_table(:clists, :id => false) do |t|
      t.integer :CID, :options => 'PRIMARY KEY'
      t.string :Category
      t.string :ProgramName
      t.integer :EpisodeNum
      t.string :VideoURL
      t.string :VideoFileName
      t.string :VideoThumb
      t.float :FPS
      t.datetime :RegisterDateTime
      t.datetime :LastSavedDateTime
      t.integer :TagStatus
      t.string :User
      t.string :ProgramNameKor
    end
    
    execute "ALTER TABLE clists ADD PRIMARY KEY (CID);"
  end
  
  def down
    drop_table(:clists)
  end
end
