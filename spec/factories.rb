FactoryGirl.define do 
	factory :booking do
		cid 'jolinds'
		title 'kodowin'
		group 'digIT'
		description 'testing'
		festansvarig { |b| b.cid }
		room Room.find_by(name: 'Hubben')
		festnumber '1234567890'
		begin_date DateTime.new(2013, 11, 1)
		end_date DateTime.new(2013, 11, 2)
	end
	factory :white_november, class: WhitelistItem do
		begin_date DateTime.new(2013,11,1)
		end_date DateTime.new(2013,12,1)
	end
end