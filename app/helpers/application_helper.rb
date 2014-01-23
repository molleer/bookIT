module ApplicationHelper

	def datetime_local_dateformat(date)
		date.strftime "%Y-%m-%dT%H:%M"
	end

	def swedish_day_names
		I18n.t(:'date.day_names').rotate
	end

	def active_weekdays(wl_item)
		wl_item.day_array.zip(swedish_day_names).select{ |active, dayname| active != 0 }.map{ |a, d| d }
	end
end
