class RenameToEnglishRooms < ActiveRecord::Migration
  def change
  	rename_column :rooms, :festrum, :allow_party
  end
end
