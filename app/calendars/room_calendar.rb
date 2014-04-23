class RoomCalendar
	def initialize(room)
		@calendar = RiCal.Calendar do |cal|
			room.bookings.within(2.months.from_now).each do |b|
				cal.event do |e|
					e.summary = b.title
					e.description = b.description
					e.dtstart = b.begin_date
					e.dtend = b.end_date
					e.location = room.name
				end
			end
		end
	end

	def to_s
		@calendar.export
	end
end
