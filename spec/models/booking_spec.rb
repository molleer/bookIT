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
		build(:booking,
			begin_date: DateTime.new(2014,1,1,17,0),
			end_date: DateTime.new(2014,1,1,21,0)).should_not be_valid
		build(:booking,
			begin_date: DateTime.now.tomorrow.change(hour: 17, minute: 0),
			end_date: DateTime.now.tomorrow.change(hour: 21, minute: 0)).should be_valid
	end

	it "should have end date after begin date" do
		build(:booking,
			begin_date: DateTime.now.tomorrow.change(hour: 21, minute: 0),
			end_date: DateTime.now.tomorrow.change(hour: 17, minute: 0)).should_not be_valid
	end

	it "should not exceed one week" do
		build(:booking,
			begin_date: DateTime.now.tomorrow.change(hour: 17, minute: 0),
			end_date: DateTime.now.tomorrow.change(hour: 21, minute: 0) + 6.days).should be_valid
		build(:booking,
			begin_date: DateTime.now.tomorrow.change(hour: 17, minute: 0),
			end_date: DateTime.now.tomorrow.change(hour: 21, minute: 0) + 8.days).should_not be_valid
	end

	it "should not collide with another booking" do
		create(:booking).should be_valid
		build(:booking).should_not be_valid
	end

	it "should not allow booking as not group" do
		build(:booking, room: create(:hubben)).should_not be_valid
	end

	it "should only allow groups which user belong to" do
		build(:booking, group: :nollkit).should_not be_valid
		build(:booking, user: create(:nollkit_user), group: :nollkit).should be_valid
	end

	it "should have a valid phone number" do
		build(:booking, phone: '636').should_not be_valid
		build(:party_booking, party_responsible_phone: '636').should_not be_valid
	end

	it "should not allow party in non-party room" do
		build(:party_booking, room: create(:grupprummet)).should_not be_valid
	end
end
