require 'it_auth'

module BookingsHelper
	def datetime_local_helper(f, name, date = DateTime.now)
		date = date.change min: 0
    	f.datetime_local_field name, 
    		value: datetime_local_dateformat(date), 
    		step: 60*60,
    		class: 'booking-dates'
	end
end
