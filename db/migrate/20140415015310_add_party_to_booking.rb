class AddPartyToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :party, :boolean
  end
end
