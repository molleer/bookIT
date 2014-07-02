# == Schema Information
#
# Table name: bookings
#
#  id                      :integer          not null, primary key
#  user_id                 :string(255)
#  begin_date              :datetime
#  end_date                :datetime
#  group                   :string(255)
#  description             :text
#  party_responsible       :string(255)
#  party_responsible_phone :string(255)
#  room_id                 :integer
#  created_at              :datetime
#  updated_at              :datetime
#  title                   :string(255)
#  party                   :boolean
#  phone                   :string(255)
#  liquor_license          :boolean
#  accepted                :boolean
#

require 'spec_helper'

describe Booking do

	it "should have valid factories" do
		build(:booking).should be_valid
		build(:party_booking).should be_valid
	end

	it "should only validate bookings in the future" do
		room = create(:grupprummet)
		build(:booking,
			room: room,
			begin_date: Time.utc(2014,1,1,17,0),
			end_date: Time.utc(2014,1,1,21,0)).should_not be_valid
		build(:booking,
			room: room,
			begin_date: Time.now.utc.tomorrow.change(hour: 17, minute: 0),
			end_date: Time.now.utc.tomorrow.change(hour: 21, minute: 0)).should be_valid
	end

	it "should have end date after begin date" do
		build(:booking,
			begin_date: Time.now.utc.tomorrow.change(hour: 21, minute: 0),
			end_date: Time.now.utc.tomorrow.change(hour: 17, minute: 0)).should_not be_valid
	end

	it "should not exceed one week" do
		room = create(:grupprummet)
		build(:booking,
			room: room,
			begin_date: Time.now.utc.tomorrow.change(hour: 17, minute: 0),
			end_date: Time.now.utc.tomorrow.change(hour: 21, minute: 0) + 6.days).should be_valid
		build(:booking,
			room: room,
			begin_date: Time.now.utc.tomorrow.change(hour: 17, minute: 0),
			end_date: Time.now.utc.tomorrow.change(hour: 21, minute: 0) + 8.days).should_not be_valid
	end

	it "should allow bookings at same time in different rooms" do
	  create(:booking)
		build(:party_booking).should be_valid
	end

	it "should allow two bookings to end and begin at the same time" do
	  room = create(:grupprummet)
		create(:booking,
			room: room,
			begin_date: Time.now.utc.tomorrow.change(hour: 17, min: 0),
			end_date: Time.now.utc.tomorrow.change(hour: 21, min: 0))
		build(:booking,
			room: room,
			begin_date: Time.now.utc.tomorrow.change(hour: 21, min: 0),
			end_date: Time.now.utc.tomorrow.change(hour: 22, min: 0)).should be_valid
	end

	it "should not collide with another booking" do
		room = create(:grupprummet)
		create(:booking,
			room: room,
			begin_date: Time.now.utc.tomorrow.change(hour: 17, min: 0),
			end_date: Time.now.utc.tomorrow.change(hour: 21, min: 0)).should be_valid
		build(:booking,
			room: room,
			begin_date: Time.now.utc.tomorrow.change(hour: 20, min: 0),
			end_date: Time.now.utc.tomorrow.change(hour: 22, min: 0)).should_not be_valid
		build(:booking,
			room: room,
			begin_date: Time.now.utc.tomorrow.change(hour: 16, min: 0),
			end_date: Time.now.utc.tomorrow.change(hour: 22, min: 0)).should_not be_valid
		build(:booking,
			room: room,
			begin_date: Time.now.utc.tomorrow.change(hour: 16, min: 0),
			end_date: Time.now.utc.tomorrow.change(hour: 20, min: 0)).should_not be_valid
		build(:booking,
			room: room,
			begin_date: Time.now.utc.tomorrow.change(hour: 18, min: 0),
			end_date: Time.now.utc.tomorrow.change(hour: 20, min: 0)).should_not be_valid
	end

	it "should not allow booking as not group" do
		build(:booking, room: create(:hubben)).should_not be_valid
	end

	it "should only allow groups which user belong to" do
		room = create(:grupprummet)
		build(:booking, room: room, group: :nollkit).should_not be_valid
		build(:booking, room: room, user: create(:nollkit_user), group: :nollkit).should be_valid
	end

	it "should have a valid phone number" do
		build(:booking, phone: '636').should_not be_valid
		build(:party_booking, party_responsible_phone: '636').should_not be_valid
	end

	it "should not allow party in non-party room" do
		build(:party_booking, room: create(:grupprummet)).should_not be_valid
	end

	it "should check against rules" do
		hubben = create(:hubben)
		gruppr = create(:grupprummet)
		create(:rule, room: hubben)
		create(:rule_deny_group_room, room: gruppr)
		create(:rule_allow_lunch_group_room, room: gruppr)
		create(:rule_deny_tentavecka, room: hubben)

		build(:booking,
			room: hubben,
			begin_date: Time.now.utc.tomorrow.change(hour: 12, min: 0),
			end_date: Time.now.utc.tomorrow.change(hour: 15, min: 0)).should_not be_valid
		build(:booking,
			room: gruppr,
			begin_date: Time.now.utc.tomorrow.change(hour: 9, min: 0),
			end_date: Time.now.utc.tomorrow.change(hour: 10, min: 0)).should_not be_valid
		build(:booking,
			room: gruppr,
			begin_date: Time.now.utc.tomorrow.change(hour: 12, min: 1),
			end_date: Time.now.utc.tomorrow.change(hour: 12, min: 59)).should be_valid
		build(:booking,
			room: gruppr,
			begin_date: Time.now.utc.tomorrow.change(hour: 14, min: 0),
			end_date: Time.now.utc.tomorrow.change(hour: 17, min: 0)).should_not be_valid

		# Multi-day bookings

		# LAN
		build(:party_booking,
			room: hubben,
			begin_date: Time.utc(2014, 7, 4, 17, 0),
			end_date: Time.utc(2014, 7, 6, 15, 0)).should be_valid

		# Måndagstest
		build(:party_booking,
			room: hubben,
			begin_date: Time.utc(2014, 7, 7, 17, 0),
			end_date: Time.utc(2014, 7, 8, 15, 0)).should_not be_valid

		# Sön-Lör
		build(:party_booking,
			room: hubben,
			begin_date: Time.utc(2014, 7, 6, 12, 0),
			end_date: Time.utc(2014, 7, 12, 15, 0)).should_not be_valid

		# Fre-Lör
		build(:party_booking,
			room: hubben,
			begin_date: Time.utc(2014, 7, 4, 17, 0),
			end_date: Time.utc(2014, 7, 5, 15, 0)).should be_valid

		# Sön-Mån
		build(:party_booking,
			room: hubben,
			begin_date: Time.utc(2014, 7, 6, 12, 0),
			end_date: Time.utc(2014, 7, 7, 8, 0)).should be_valid

		# Standard festbokning
		build(:party_booking,
			room: hubben,
			begin_date: Time.utc(2014, 7, 7, 17, 0),
			end_date: Time.utc(2014, 7, 8, 2, 0)).should be_valid
	end
end
