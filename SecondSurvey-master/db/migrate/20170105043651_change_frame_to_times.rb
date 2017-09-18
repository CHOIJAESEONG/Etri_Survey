class ChangeFrameToTimes < ActiveRecord::Migration[5.0]
  def up
    change_column :shot_infos, :StartFrame, :string
    change_column :shot_infos, :EndFrame, :string
  end
  
  def down
    change_column :shot_infos, :StartFrame, :integer
    change_column :shot_infos, :EndFrame, :integer
  end
end
