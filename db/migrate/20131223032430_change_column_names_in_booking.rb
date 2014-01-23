class ChangeColumnNamesInBooking < ActiveRecord::Migration
  def change
  	change_table :bookings do |t|
  		t.rename :end, :end_date
  		t.rename :start, :begin_date
  	end
  end
end
