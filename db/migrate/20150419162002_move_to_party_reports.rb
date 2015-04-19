class MoveToPartyReports < ActiveRecord::Migration
  def up
    Booking.party_reported.find_each do |b|
      booking_attrs = b.slice(:party_responsible_phone, :liquor_license, :sent, :accepted, :created_at, :begin_date, :end_date)
      p booking_attrs
      PartyReport.create(booking_attrs) do |pr|
        pr.booking = b
        pr.party_responsible_name = b.party_responsible
      end
    end
    remove_column :bookings, :party_responsible
    remove_column :bookings, :party_responsible_phone
    remove_column :bookings, :liquor_license
    remove_column :bookings, :sent
    remove_column :bookings, :accepted
    remove_column :bookings, :party
  end

  def down
    add_column :bookings, :party_responsible, :string
    add_column :bookings, :party_responsible_phone, :string
    add_column :bookings, :liquor_license, :boolean
    add_column :bookings, :sent, :boolean
    add_column :bookings, :accepted, :boolean
    add_column :bookings, :party, :boolean
    PartyReport.find_each do |pr|
      pr_attributes = pr.slice(:party_responsible_phone, :liquor_license, :sent, :accepted)
      pr.booking.update(pr_attributes) do |b|
        b.party = true
        b.party_responsible = pr.party_responsible_name
      end
    end
  end
end
