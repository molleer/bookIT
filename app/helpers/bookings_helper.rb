module BookingsHelper
	def datetime_local_helper(f, name, date = DateTime.now)
		date = f.object[name] || date.change(min: 0)
  	f.datetime_local_field name,
  		value: datetime_local_dateformat(date),
  		step: 1.hour,
  		class: 'booking-dates'
	end

	def booked_by(booking)
		(booking.group.empty? && booking.cid) || booking.group
	end
end
