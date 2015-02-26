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
#  sent                    :boolean
#  deleted_at              :datetime
#

require 'spec_helper'

describe Booking do

	before :all do
		t = Time.local(2014, 7, 1, 10, 0)
		Timecop.freeze(t)
	end

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
		build(:booking, room: room, user: create(:nollkit_user)).should be_valid
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
		create(:rule, rooms: [hubben])
		create(:rule_deny_group_room, rooms: [gruppr])
		create(:rule_allow_lunch_group_room, rooms: [gruppr])
		create(:rule_deny_tentavecka, rooms: [hubben])

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
		build(:booking,
			room: gruppr,
			begin_date: Time.utc(2014, 7, 4, 12, 0),
			end_date: Time.utc(2014, 7, 4, 19, 0)).should_not be_valid

		# Multi-day bookings

		# LAN
		build(:party_booking,
			title: 'LAN',
			room: hubben,
			begin_date: Time.utc(2014, 7, 4, 17, 0),
			end_date: Time.utc(2014, 7, 6, 15, 0)).should be_valid

		# Måndagstest
		build(:party_booking,
			title: 'Måndagstest',
			room: hubben,
			begin_date: Time.utc(2014, 7, 7, 17, 0),
			end_date: Time.utc(2014, 7, 8, 15, 0)).should_not be_valid

		# Sön-Lör
		build(:party_booking,
			title: 'Sön-Lör',
			room: hubben,
			begin_date: Time.utc(2014, 7, 6, 12, 0),
			end_date: Time.utc(2014, 7, 12, 15, 0)).should_not be_valid

		# Fre-Lör
		build(:party_booking,
			title: 'Fre-Lör',
			room: hubben,
			begin_date: Time.utc(2014, 7, 4, 17, 0),
			end_date: Time.utc(2014, 7, 5, 15, 0)).should be_valid

		# Sön-Mån
		build(:party_booking,
			title: 'Sön-Mån',
			room: hubben,
			begin_date: Time.utc(2014, 7, 6, 12, 0),
			end_date: Time.utc(2014, 7, 7, 8, 0)).should be_valid

		# Standard festbokning
		build(:party_booking,
			title: 'Standard festbokning',
			room: hubben,
			begin_date: Time.utc(2014, 7, 7, 17, 0),
			end_date: Time.utc(2014, 7, 8, 2, 0)).should be_valid

		# 8-bit bugg
		build(:booking,
			title: '8-bit bugg',
			room: gruppr,
			begin_date: Time.utc(2014, 7, 6, 21, 0),
			end_date: Time.utc(2014, 7, 8, 12, 0)).should_not be_valid
	end


	it "should allow single day fest" do
		hubben = create(:hubben)
		gruppr = create(:grupprummet)
		create(:rule,
			title: 'Lunchmöte',
			prio: 9,
			start_date: Time.utc(2001, 1, 1),
			stop_date: Time.utc(2030, 1, 1),
			start_time: "12:00",
			stop_time: "13:00",
			rooms: [gruppr],
			day_mask: 0b1111100,
			allow: true
		)
		create(:rule,
			title: 'Läsdag',
			prio: 10,
			start_date: Time.utc(2001, 1, 1),
			stop_date: Time.utc(2030, 1, 1),
			start_time: "08:00",
			stop_time: "17:00",
			rooms: [gruppr, hubben],
			day_mask: 0b1111100,
			allow: false
		)
		create(:booking,
			title: 'fest en hel helg',
			description: 'festar hela helgeeeen!',
			room: gruppr,
			party: false,
			begin_date: Time.utc(2014, 9, 6, 12, 0),
			end_date: Time.utc(2014, 9, 6, 23, 0)
		).should be_valid
	end
end
