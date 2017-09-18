class CreateShotInfos < ActiveRecord::Migration[5.0]
  def up
    create_table :shot_infos do |t|
      t.integer :ShotID
      t.integer :ShotNum
      t.integer :StartFrame
      t.integer :EndFrame
      t.string :ThumbURL
      t.integer :CID
    end

    execute "ALTER TABLE shot_infos ADD constraint fk_CID_from_clist foreign key (CID) references clists (CID) ON DELETE cascade;"
  end
  
  def down
    drop_table(:shot_infos)
  end
end
