namespace :bookit do
	desc "Import json into database, give path to .json-file as argument"
	task import: :environment do
		json = JSON.parse File.read ARGV[1]
		json.each do |b|
			location = b['room']
			b['room_id'] = Room.find_by(name: location).id
			b['user_id'] = b['cid']


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

			b['description'] = b['title'] if b['description'].empty?

			b.delete 'cid'
			b.delete 'id'
			b.delete 'room'

			begin
				Booking.create!(b)
			rescue => e
				puts b.inspect
				puts location
				puts e
			end
		end
	end
end
