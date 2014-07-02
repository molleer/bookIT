class AddRoomToRule < ActiveRecord::Migration
  def change
    add_reference :rules, :room, index: true
  end
end
