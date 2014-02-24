# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  festrum    :boolean
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Room do
	let(:hubben) { Room.find_by(name: 'Hubben') }
	let(:grupprummet) { Room.find_by(name: 'Grupprummet') }
	it 'should have bookings' do
		create(:white_november)
		create(:booking, title: 'aspning - vim', room: hubben)
		create(:booking, title: 'aspning - regex', room: hubben)
		hubben.bookings.length.should eq 2
	end
end
