FactoryGirl.define do
	factory :user do
		sequence(:cid) {|n| "smurf#{n}"}
		nick 'Smurf'
		first_name 'Test'
		last_name 'Testsson'
		sequence(:mail) { |n| "smurf#{n}@example.com" }

		factory :nollkit_user do
		end
	end
	factory :booking do
		title 'kod&vin'
		description 'digIT kodar hubbIT'
		user
		phone '0303030303'
		association :room, factory: :grupprummet
		party false
		begin_date { DateTime.now.tomorrow.change(hour: 17) }
		end_date { DateTime.now.tomorrow.change(hour: 21) }

		factory :party_booking do
			title 'party'
			description 'digIT har fest!'
			association :room, factory: :hubben
			party true
			association :user, factory: :nollkit_user
			phone '0020202020'
			party_responsible 'Johan Lindskogen'
			party_responsible_phone '0020202020'
			liquor_license true
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

	factory	:rule do
		title 'Läsveckor'
		day_mask 0b1111100
		start_date DateTime.new(1970, 1, 1)
		stop_date DateTime.new(3000, 1, 1)
		start_time Time.utc(1990, 1, 1, 8, 0, 0)
		stop_time Time.utc(1990, 1, 1, 17, 0, 0)
		allow false
		prio 20
		reason 'Du bör vara på din lektion under denna tiden (läsveckor)'

		factory :rule_deny_group_room do
			title 'Boka ej grupprum på vardagar'
			day_mask 0b1111100
			prio 20
			reason 'Du bör vara på din lektion under denna tiden (grupp vardagar)'

			factory :rule_allow_lunch_group_room do
				title 'Tillåt lunchmöten i grupprum'
				prio 19
				start_time Time.utc(1990, 1, 1, 12, 0, 0)
				stop_time Time.utc(1990, 1, 1, 13, 0, 0)
				allow true
				reason 'Lunchmöte är ok!'
			end
		end

		factory :rule_deny_tentavecka do
			title 'Tentavecka'
			prio 2
			start_date DateTime.new(2014, 10, 25)
			stop_date DateTime.new(2014, 11, 1)
			start_time nil
			stop_time nil
			allow false
			reason 'Du skall plugga, inte prokrastinera!'
		end
	end
end
