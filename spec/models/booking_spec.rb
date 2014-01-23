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
