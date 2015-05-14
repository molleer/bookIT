class RoomCalendar
	def initialize(room, url)
		interval = 2.months
		@calendar = RiCal.Calendar do |cal|
			cal.add_x_property 'x_wr_calname', "#{room.name} - bookIT"
			cal.add_x_property 'x_wr_caldesc', "Bokningar av #{room.name} ifrån bookIT"
			cal.add_x_property 'url', url
			cal.prodid = 'bookIT'
			room.bookings.from_date(interval.ago).each do |b|
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
