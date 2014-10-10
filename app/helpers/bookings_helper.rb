module BookingsHelper
	def datetime_local_helper(f, name, date = DateTime.now)
		date = f.object[name] || date.change(min: 0)
  	f.datetime_local_field name,
  		value: datetime_local_dateformat(date),
  		step: 1.hour,
  		class: 'booking-dates',
			required: true
	end

	def booked_by(booking)
		(booking.group.empty? && booking.user) || booking.group_sym.itize
	end

	def user_bookings_path(user)
		bookings_path(filter: ([user.cid] + user.groups).join(' '))
	end
end
