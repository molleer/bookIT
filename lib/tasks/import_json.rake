namespace :bookit do
	desc "Import json into database, give path to .json-file as argument"
	task import: :environment do
		json = JSON.parse File.read ARGV[1]
		json.each do |b|
			b['room_id'] = Room.find_by(name: b['location']).id
			if b['group'].present?
				b['group'].downcase!
				b['group'].gsub!(/[-\.]/, '')
				b['group'].gsub!('fanbärare', 'fanbarerit')
			end
			if b['party_responsible_phone'].present?
				b['party'] = true
				b['party_responsible'] = User.find(b['user_id']).full_name
			else
				b['party'] = false
			end
			b.delete 'location'
			b.delete 'id'
			begin
				Booking.create!(b)
			rescue => e
				puts b.inspect
				puts e
			end
		end
	end
end
