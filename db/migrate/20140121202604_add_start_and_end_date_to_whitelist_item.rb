class AddStartAndEndDateToWhitelistItem < ActiveRecord::Migration
  def change
    change_table :whitelist_items do |t|
      t.integer :days_in_week
      t.date :rule_start
      t.date :rule_end

      t.change :begin_date, :time
      t.rename :begin_date, :begin_time
      
      t.change :end_date, :time
      t.rename :end_date, :end_time
    end
  end
end
