# == Schema Information
#
# Table name: whitelist_items
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  begin_time   :time
#  end_time     :time
#  created_at   :datetime
#  updated_at   :datetime
#  days_in_week :integer
#  rule_start   :date
#  rule_end     :date
#  blacklist    :boolean
#

class WhitelistItem < ActiveRecord::Base
	scope :active, -> { where('rule_end >= ?', Date.today) }

	validates :title, :begin_time, :end_time, :rule_start, :rule_end, :days_in_week, presence: true

	# declares a method for each day like 'saturday?', returns true if item is defined on this weekday
	%w(mon tues wednes thurs fri satur sun).each_with_index do |day, i|
		define_method "#{day}day?" do
			! self.days_in_week.nil? && self.days_in_week & (1 << 6 - i) > 0
		end
	end

	def to_s
		"\"#{title}\" (#{rule_start.strftime(NAT_DATE)} - #{rule_end.strftime(NAT_DATE)}, on: #{days_in_week.to_s(2)}): #{begin_time.strftime(NAT_TIME)}-#{end_time.strftime(NAT_TIME)}"
	end

	def days=(*array)
		array = array[0] if array.length == 1 && array[0].is_a?(Array)
		wkdays = [:mon, :tue, :wed, :thu, :fri, :sun, :sat]
		if array.include? :all
			result = [1, 1, 1, 1, 1, 1, 1]
			return self.day_array = result
		elsif array.include? :weekdays
			result = [1, 1, 1, 1, 1, 0, 0]
		elsif array.include? :weekends
			result = [0, 0, 0, 0, 0, 1, 1]
		else
			result = [0, 0, 0, 0, 0, 0, 0]
		end
		array.each do |d|
			result[wkdays.index(d)] = 1 if wkdays.include?(d)
		end
		self.day_array = result
	end

	def range
		begin_time..end_time
	end

	def day_array
		(self.days_in_week || 0).to_s(2).rjust(7, '0').split("").map(&:to_i)
	end

	def day_array=(array)
		array = array.values if array.is_a? Hash
		self.days_in_week = array.join.to_i(2) if array.present?
	end

	def days_human_format
		res = ''
		days = day_array
		%w(M T W T F S S).each_with_index do |s, i|
			res += day_array[i] == 1 && s || '-'
		end
		res
	end

private

	NAT_DATE = '%-d/%-m'
	NAT_TIME = '%R'
end
