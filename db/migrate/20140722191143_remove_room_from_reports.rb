class RemoveRoomFromReports < ActiveRecord::Migration
  def change
    remove_column :rules, :room_id, :integer
  end
end
