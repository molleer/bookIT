class AddLiquorLicenseToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :liquor_license, :boolean
  end
end
