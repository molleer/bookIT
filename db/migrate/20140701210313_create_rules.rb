class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.integer :day_mask
      t.datetime :start_date
      t.datetime :stop_date
      t.time :start_time
      t.time :stop_time
      t.boolean :allow
      t.integer :prio
      t.text :reason
      t.string :title

      t.timestamps
    end
  end
end
