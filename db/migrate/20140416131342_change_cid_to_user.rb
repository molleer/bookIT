class ChangeCidToUser < ActiveRecord::Migration
  def change
    rename_column :bookings, :cid, :user_id
  end
end
