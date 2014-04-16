FactoryGirl.define do
	factory :booking do
		title 'kod&vin'
		description 'digIT kodar hubbIT'
		cid 'jolinds'
		phone '0303030303'
		room { create(:grupprummet) }
		party false
		begin_date { DateTime.now.tomorrow.change(hour: 17) }
		end_date { DateTime.now.tomorrow.change(hour: 21) }

		factory :party_booking do
			title 'party'
			description 'digIT har fest!'
			room { create(:hubben) }
			group 'digIT'
			party true
			phone '0020202020'
			party_responsible 'Johan Lindskogen'
			party_responsible_phone '0020202020'
		end
	end

	factory :room do
		factory :hubben do
			name 'Hubben'
			allow_party true
			only_group true
		end
		factory :grupprummet do
			name 'Grupprummet'
			allow_party false
			only_group false
		end
	end

	factory :whitelist_item do
		title 'Lov'
		begin_time '8:00'
		end_time '23:59'
		days_in_week 0b1111111
		rule_start DateTime.now.beginning_of_year
		rule_end DateTime.now.end_of_year
	end
end
