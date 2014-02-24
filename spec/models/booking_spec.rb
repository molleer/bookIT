# == Schema Information
#
# Table name: bookings
#
#  id           :integer          not null, primary key
#  cid          :string(255)
#  begin_date   :datetime
#  end_date     :datetime
#  group        :string(255)
#  description  :text
#  festansvarig :string(255)
#  festnumber   :string(255)
#  room_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#  title        :string(255)
#

require 'spec_helper'

describe Booking do
	it "should not verify" do
		WhitelistItem.create(title: "November 2013", 
							begin_date: DateTime.new(2013,11,1), 
							end_date: DateTime.new(2013, 12,1))
		build(:booking, begin_date: DateTime.new(2013, 10, 10), 
						end_date: DateTime.new(2013, 10, 13)).should_not be_valid
	end
	it "should verify" do
		WhitelistItem.create(title: "November 2013", 
							begin_date: DateTime.new(2013,11,1), 
							end_date: DateTime.new(2013, 12,1))
		build(:booking, begin_date: DateTime.new(2013, 11, 2), 
						end_date: DateTime.new(2013, 11, 3)).should be_valid
	end
end
