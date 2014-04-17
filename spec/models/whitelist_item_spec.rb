# == Schema Information
#
# Table name: whitelist_items
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  begin_time   :time
#  end_time     :time
#  created_at   :datetime
#  updated_at   :datetime
#  days_in_week :integer
#  rule_start   :date
#  rule_end     :date
#  blacklist    :boolean
#

require 'spec_helper'

describe WhitelistItem do
	it "should have valid factories" do
		build(:whitelist_item).should be_valid
	end
end
