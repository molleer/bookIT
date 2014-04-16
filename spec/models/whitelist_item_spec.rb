require 'spec_helper'

describe WhitelistItem do
	it "should have valid factories" do
		build(:whitelist_item).should be_valid
	end
end
