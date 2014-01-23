module BookingsHelper
	def datetime_local_helper(f, name, date = DateTime.now)
		date = date.change min: date.minute / 15 * 15
    	f.datetime_local_field name, 
    		value: datetime_local_dateformat(date), 
    		step: 60*15
	end
end
