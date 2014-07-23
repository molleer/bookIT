class AddSentToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :sent, :boolean
  end
end
