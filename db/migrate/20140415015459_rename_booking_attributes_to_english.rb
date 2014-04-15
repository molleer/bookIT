class RenameBookingAttributesToEnglish < ActiveRecord::Migration
  def change
  	rename_column :bookings, :festansvarig, :party_responsible
  	rename_column :bookings, :festnumber, :party_responsible_phone
  	add_column :bookings, :phone, :string
  end
end
