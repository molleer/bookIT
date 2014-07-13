class CreateRuleToRoomTable < ActiveRecord::Migration
  def change
    create_join_table :rooms, :rules, id: false do |t|
      t.integer :room_id
      t.integer :rule_id
      t.index :room_id
      t.index :rule_id
    end
  end
end
