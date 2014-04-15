class RoomCalendar < RiCal::Component::Calendar
	def initialize(room)
		room.bookings.within(2.months.from_now).each do |b|
			event do |e|
				e.description = b.description
				e.dtstart = b.begin_date
				e.dtend = b.end_date
				e.location = room.name
			end
		end
	end
end
